/*
    ContentView.swift
    SwiftUITextFieldAlert

    Created by Jeff Spooner on 2022-03-17.
*/

import SwiftUI


struct ContentView: View
  {
    @State var text: String = "Default Text"
    @State var alertPresented: Bool = false

    var body: some View
      {
        VStack {
          Button(action: { alertPresented = true }, label: { Text("Present Alert") })

          Divider()

          Text("\(text)")
        }
        .textFieldAlert(title: "Custom Alert",
                        message: "Enter some text",
                        text: $text,
                        isPresented: $alertPresented,
                        completion: {
                          print("Text is now: \(text)")
                        })
      }
  }


struct ContentView_Previews: PreviewProvider
  {
    static var previews: some View
      {
        ContentView()
      }
  }
