1. UITableViewCell简单实现cell的缩进 (类似树形node节点展开的效果)

```objc
   // 缩进方式 ①
   cell.indentationLevel = node.depth;  // 缩进等级，从 0 开始
   cell.indentationWidth = 30;  // 每级缩进 30pt
    
    // 缩进方式 ②
    cell.separatorInset = UIEdgeInsetsMake(0, 15 + 40 * node.depth, 0, 0);

```

2. autoLayout自适应UITableView高度
```objc
/// AutosizedTableView is a convenient UITableView that makes dynamic sizing easier when using Auto Layout
class AutosizedTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
}

```