//
//  MacEditor.swift
//  Collider
//
//  Created by Max Desiatov on 10/01/2021.
//

import AppKit

typealias TextStorage = NSTextStorage

private extension NSSize {
  static var greatestFiniteHeight: Self {
    .init(width: 0, height: CGFloat.greatestFiniteMagnitude)
  }

  static var greatestFiniteMagnitude: Self {
    .init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
  }
}

final class MacEditor: NSScrollView {
  override init(frame: NSRect) {
    super.init(frame: frame)

    let storage = NSTextStorage()
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: .greatestFiniteHeight)

    textContainer.widthTracksTextView = true
    layoutManager.addTextContainer(textContainer)
    storage.addLayoutManager(layoutManager)
    let textView = NSTextView(frame: frame, textContainer: textContainer)

    borderType = .noBorder
    hasVerticalScroller = true
    hasHorizontalScroller = false
    scrollerKnobStyle = .light

    documentView = textView

    textView.minSize = .init(width: 0.0, height: bounds.height)
    textView.maxSize = .greatestFiniteMagnitude
    textView.isVerticallyResizable = true
    textView.isHorizontallyResizable = false
    textView.autoresizingMask = [.width, .height]
    textView.isEditable = true
    textView.isAutomaticQuoteSubstitutionEnabled = false
    textView.allowsUndo = true
    textView.usesFindBar = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
