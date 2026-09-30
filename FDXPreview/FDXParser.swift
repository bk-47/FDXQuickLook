import AppKit

enum FDXParser {

    static func attributedString(from url: URL) throws -> NSAttributedString {
        let doc = try XMLDocument(contentsOf: url, options: [])
        let out = NSMutableAttributedString()

        // Optional title page.
        if let titleParas = try? doc.nodes(forXPath: "/FinalDraft/TitlePage/Content/Paragraph"),
           !titleParas.isEmpty {
            for node in titleParas {
                guard let el = node as? XMLElement else { continue }
                out.append(styled(text: text(in: el), type: "TitlePage"))
            }
            out.append(NSAttributedString(string: "\n"))
        }

        // Script body.
        let paras = try doc.nodes(forXPath: "/FinalDraft/Content/Paragraph")
        for node in paras {
            guard let el = node as? XMLElement else { continue }
            let type = el.attribute(forName: "Type")?.stringValue ?? "Action"
            out.append(styled(text: text(in: el), type: type))
        }

        if out.length == 0 {
            return NSAttributedString(
                string: "This doesn't look like a Final Draft script, or it has no readable content.",
                attributes: [.font: NSFont.systemFont(ofSize: 13)])
        }
        return out
    }

    private static func text(in paragraph: XMLElement) -> String {
        var s = ""
        if let runs = try? paragraph.nodes(forXPath: ".//Text") {
            for r in runs { s += r.stringValue ?? "" }
        }
        if s.isEmpty { s = paragraph.stringValue ?? "" }
        return s.trimmingCharacters(in: .whitespaces)
    }

    private static func styled(text: String, type: String) -> NSAttributedString {
        let size: CGFloat = 12
        let regular = NSFont(name: "Courier New", size: size)
            ?? NSFont.monospacedSystemFont(ofSize: size, weight: .regular)
        let bold = NSFontManager.shared.convert(regular, toHaveTrait: .boldFontMask)

        let inch: CGFloat = 96
        let p = NSMutableParagraphStyle()
        var font = regular
        var display = text

        switch type {
        case "Scene Heading":
            font = bold
            display = text.uppercased()
            p.paragraphSpacingBefore = 16
        case "Character":
            display = text.uppercased()
            p.firstLineHeadIndent = 2.0 * inch
            p.headIndent = 2.0 * inch
            p.paragraphSpacingBefore = 8
        case "Parenthetical":
            p.firstLineHeadIndent = 1.6 * inch
            p.headIndent = 1.6 * inch
        case "Dialogue":
            p.firstLineHeadIndent = 1.0 * inch
            p.headIndent = 1.0 * inch
            p.tailIndent = -1.0 * inch
        case "Transition":
            display = text.uppercased()
            p.alignment = .right
            p.paragraphSpacingBefore = 8
        case "Shot":
            font = bold
            display = text.uppercased()
            p.paragraphSpacingBefore = 8
        case "TitlePage":
            p.alignment = .center
        default: // Action, General, etc.
            p.paragraphSpacingBefore = 8
        }

        return NSAttributedString(string: display + "\n", attributes: [
            .font: font,
            .paragraphStyle: p,
            .foregroundColor: NSColor.black
        ])
    }
}
