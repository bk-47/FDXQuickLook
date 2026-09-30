import Cocoa
import Quartz   // If QLPreviewingController isn't found, change this line to: import QuickLookUI

class PreviewViewController: NSViewController, QLPreviewingController {

    private let scrollView = NSScrollView()
    private let textView = NSTextView()

    override func loadView() {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 820, height: 1060))

        scrollView.frame = container.bounds
        scrollView.autoresizingMask = [.width, .height]
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = true
        scrollView.backgroundColor = .white

        textView.isEditable = false
        textView.isSelectable = true
        textView.drawsBackground = true
        textView.backgroundColor = .white
        textView.textContainerInset = NSSize(width: 28, height: 28)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.minSize = NSSize(width: 0, height: 0)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true

        scrollView.documentView = textView
        container.addSubview(scrollView)
        self.view = container
    }

    func preparePreviewOfFile(at url: URL) async throws {
        let attributed = try FDXParser.attributedString(from: url)
        await MainActor.run {
            textView.textStorage?.setAttributedString(attributed)
            textView.scroll(NSPoint(x: 0, y: 0))
        }
    }
}
