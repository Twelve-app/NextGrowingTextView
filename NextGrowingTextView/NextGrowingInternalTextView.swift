// NextGrowingInternalTextView.swift
//
// Copyright (c) 2015 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

// MARK: - NextGrowingInternalTextView: UITextView

internal class NextGrowingInternalTextView: UITextView {

    // MARK: - Internal

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        NotificationCenter.default.addObserver(self, selector: #selector(NextGrowingInternalTextView.textDidChangeNotification(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var text: String! {
        didSet {
            updatePlaceholder()
        }
    }

    var placeholderAttributedText: NSAttributedString? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard displayPlaceholder == true else {
            return
        }

        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        let targetRect = CGRect(
            x: 5 + textContainerInset.left,
            y: textContainerInset.top,
            width: frame.size.width - (textContainerInset.left + textContainerInset.right),
            height: frame.size.height - (textContainerInset.top + textContainerInset.bottom)
        )

        let attributedString = placeholderAttributedText
        attributedString?.draw(in: targetRect)
    }

    // MARK: Private

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if tag > 0 {
            if action == #selector(paste(_:)) {
                return false
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }

    fileprivate var displayPlaceholder: Bool = true {
        didSet {
            if oldValue != self.displayPlaceholder {
                self.setNeedsDisplay()
            }
        }
    }

    @objc fileprivate dynamic func textDidChangeNotification(_ notification: Notification) {
        updatePlaceholder()
    }

    fileprivate func updatePlaceholder() {
        displayPlaceholder = text.characters.count == 0
    }
}
