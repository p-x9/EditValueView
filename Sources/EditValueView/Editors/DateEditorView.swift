//
//  DateEditorView.swift
//  
//
//  Created by p-x9 on 2022/10/21.
//  
//

import SwiftUI

struct DateEditorView: View {

    let key: String
    @Binding private var value: Date

    init(_ value: Binding<Date>, key: String) {
        _value = value
        self.key = key
    }

    var body: some View {
        VStack {
            Text(value.description)
                .frame(maxWidth: .infinity)
                .border(Color.iOS(.label), width: 0.5)
            DatePicker(key, selection: $value)
                .datePickerStyle(.graphical)
        }
    }
}
