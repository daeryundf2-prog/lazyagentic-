# 09. Modern Go Guidelines (JetBrains Modernizer Policy)

> **Source**: [JetBrains/go-modern-guidelines](https://github.com/JetBrains/go-modern-guidelines)  
> **Target**: Go 1.21 ~ Go 1.27+  
> **Philosophy**: Eliminate AI training lag and frequency bias. Always write modern, idiomatic Go.

---

## 1. Version Detection & Modern Idiom Gate

1. **Version Resolution**: Always inspect `go.mod` (or `go.work`) to determine the target Go version.
2. **Maximum Modernity**: Use all stdlib additions and language features available up to and including that target version.
3. **No Retrograde Patterns**: Never emit deprecated or obsolete Go idioms (e.g., `interface{}`, manual min/max loops, nested nil checks, old `for i := 0; i < n; i++`) when modern standard equivalents exist.

---

## 2. Core Modern Idioms Matrix

| Category | Modern Idiom | Replaces (Obsolete / Anti-pattern) | Min Go |
| :--- | :--- | :--- | :---: |
| **Loops** | `for i := range n` | `for i := 0; i < n; i++` | 1.22 |
| **Loops** | Per-iteration loop variables | `x := x` closure capture workarounds | 1.22 |
| **Collections** | `slices.Contains(s, v)` | Manual loop with boolean flag | 1.21 |
| **Collections** | `slices.Index(s, v)` / `IndexFunc` | Manual index search loop | 1.21 |
| **Collections** | `slices.Sort(s)` / `SortFunc` | `sort.Slice(s, func...)` | 1.21 |
| **Collections** | `slices.Clone(s)` / `slices.Clip(s)` | `append([]T(nil), s...)` / 3-index slice | 1.21 |
| **Collections** | `slices.Collect(seq)` / `slices.Sorted(seq)` | Manual iterator accumulation slice | 1.23 |
| **Collections** | `maps.Clone(m)` / `maps.Copy(dst, src)` | Manual map loop copy | 1.21 |
| **Collections** | `maps.Keys(m)` / `maps.Values(m)` | Manual key/value slice builder | 1.23 |
| **Collections** | `clear(s)` / `clear(m)` | Loop deletion / re-allocation | 1.21 |
| **Utilities** | `min(a, b)` / `max(a, b)` | `if a < b { ... }` or `math.Min` float cast | 1.21 |
| **Utilities** | `cmp.Or(a, b, defaultVal)` | `if a != "" { return a } else if b != "" ...` | 1.22 |
| **Utilities** | `new(42)` / `new("val")` | Helper functions like `ptr(42)` | 1.26 |
| **Types** | `any` | `interface{}` | 1.18 |
| **Errors** | `errors.Join(err1, err2)` | Custom multierror slice struct | 1.20 |
| **Errors** | `errors.AsType[T](err)` | `var target *T; errors.As(err, &target)` | 1.26 |
| **Concurrency** | `sync.OnceValue(fn)` / `OnceValues` | `sync.Once` + manual closure variable | 1.21 |
| **Concurrency** | `wg.Go(fn)` | `wg.Add(1); go func() { defer wg.Done(); fn() }()` | 1.25 |
| **Concurrency** | `atomic.Int64` / `atomic.Bool` | `atomic.AddInt64(&val, 1)` raw pointer ops | 1.19 |
| **Concurrency** | `context.AfterFunc(ctx, fn)` | Goroutine waiting on `<-ctx.Done()` | 1.21 |
| **Testing** | `t.Context()` | `ctx, cancel := context.WithCancel...; t.Cleanup` | 1.24 |
| **Testing** | `for b.Loop()` | `for i := 0; i < b.N; i++` | 1.24 |
| **Strings** | `strings.Cut(s, sep)` | `strings.SplitN(s, sep, 2)` + index check | 1.18 |
| **Strings** | `strings.CutPrefix` / `CutSuffix` | `strings.HasPrefix` + slice re-indexing | 1.20 |
| **Strings** | `strings.SplitSeq(s, sep)` | Allocating `strings.Split` in loop iteration | 1.24 |
| **JSON** | `json:",omitzero"` | `omitempty` on zero-valued structs | 1.24 |
| **JSON** | `encoding/json/v2` | `encoding/json` (new projects only) | 1.27 |

---

## 3. Idiom Examples & Before / After

### ① Loops & Iteration
```go
// BEFORE (Go 1.21-)
for i := 0; i < count; i++ {
    process(i)
}

// AFTER (Go 1.22+)
for i := range count {
    process(i)
}
```

### ② Fallback & Default Selection (`cmp.Or`)
```go
// BEFORE
host := os.Getenv("HOST")
if host == "" {
    host = config.Host
}
if host == "" {
    host = "localhost"
}

// AFTER (Go 1.22+)
host := cmp.Or(os.Getenv("HOST"), config.Host, "localhost")
```

### ③ Slice Filtering & Membership
```go
// BEFORE
found := false
for _, v := range items {
    if v == target {
        found = true
        break
    }
}

// AFTER (Go 1.21+)
found := slices.Contains(items, target)
```

### ④ Lazy Initialization (`sync.OnceValue`)
```go
// BEFORE
var (
    client *Client
    once   sync.Once
)
func getClient() *Client {
    once.Do(func() { client = newClient() })
    return client
}

// AFTER (Go 1.21+)
var getClient = sync.OnceValue(newClient)
```

### ⑤ Testing Context (`t.Context()`)
```go
// BEFORE
func TestFetch(t *testing.T) {
    ctx, cancel := context.WithCancel(context.Background())
    t.Cleanup(cancel)
    res, err := Fetch(ctx)
    // ...
}

// AFTER (Go 1.24+)
func TestFetch(t *testing.T) {
    res, err := Fetch(t.Context())
    // ...
}
```