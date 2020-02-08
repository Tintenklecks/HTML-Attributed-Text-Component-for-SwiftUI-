//
//  ContentView.swift
//  SwiftUI Component for Attributed HTML Text
//
//  Created by Ingo Böhme on 08.02.20.
//  Copyright © 2020 Ingo Böhme. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let testText =
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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("HTML Source Text:").font(.headline).padding()
            Text(testText)

            Divider()

            Text("Formatted Text:").font(.headline).padding()
            AttributedText(testText)

            Divider()

            Text("Sourcecode:").font(.headline).padding()
            AttributedText("<b>AttributedText</b>(<i>testText</i>)")
                 .font(.system(size: 24, design: .monospaced))
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
