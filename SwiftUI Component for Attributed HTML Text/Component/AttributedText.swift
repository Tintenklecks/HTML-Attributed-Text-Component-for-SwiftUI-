import SwiftUI

/// AttributedText is a way to show some HTML-tagged text in a
/// SwiftUI Text View WITHOUT using UIKit
/// Currently only the tags <b> and <i> are supported

struct AttributedText: View {
    let content: String

    init(_ content: String) {
        self.content = content
    }

    var body: some View {
        formattedWithHTML(string: content)
    }

    private func formattedWithHTML(string: String) -> Text {
        let data = Data("<XML>\(string)</XML>".utf8)
        let parser = HTML2TextParser(data: data)
        parser.delegate = parser
        if parser.parse() {
            return parser.resultText
        }
        return Text("")
    }
}

private class HTML2TextParser: XMLParser, XMLParserDelegate {
    private var isBold = false
    private var isItalic = false
    var resultText = Text("")

    override init(data: Data) {
        super.init(data: data)
    }

    private func addChunkOfText(contentText: String) {
        guard contentText != "" else {
            return
        }
        var textChunk = Text(contentText)
        textChunk = isBold ? textChunk.bold() : textChunk
        textChunk = isItalic ? textChunk.italic() : textChunk
        resultText = resultText + textChunk
    }

    // MARK: - Delegate methods of XMLParserDelegate -

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName.uppercased() == "B" {
            isBold = true
        } else if elementName.uppercased() == "I" {
            isItalic = true
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName.uppercased() == "B" {
            isBold = false
        } else if elementName.uppercased() == "I" {
            isItalic = false
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        addChunkOfText(contentText: string)
    }
}

struct AttributedText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AttributedText(
                """
                Two roads diverged in a yellow wood,
                And sorry <b>I could not travel both</b>
                And be one traveler, long I stood
                And looked down one as far as I could
                To where it bent in the undergrowth;

                <i>Two roads diverged in a wood, and I—
                I took the one less traveled by,
                And that has made all the difference.</i>
                """
            )
            Divider()
            Text("HTML Source Text:").font(.headline)
            Text(
                """
                Two roads diverged in a yellow wood,
                And sorry <b>I could not travel both</b>
                And be one traveler, long I stood
                And looked down one as far as I could
                To where it bent in the undergrowth;

                <i>Two roads diverged in a wood, and I—
                I took the one less traveled by,
                And that has made all the difference.</i>
                """
            )
            Spacer()
        }
    }
}
