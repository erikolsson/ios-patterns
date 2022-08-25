//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-25.
//

import UIKit
import SwiftUI
import ComposableArchitecture

public class FormSwiftUIViewController: UIHostingController<FormView> {

  public init(store: Store<Form.State, Form.Action>) {
    super.init(rootView: FormView(store: store))
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
}

public struct FormView: View {

  let store: Store<Form.State, Form.Action>
  public var body: some View {
    List {
      WithViewStore(store) { viewStore in

        Section("Edit Profile") {
          Group {
            ToggleView(title: "Likes giraffes", binding: viewStore.binding(\.userProfile.$likesGiraffes))
            ToggleView(title: "Likes horses", binding: viewStore.binding(\.userProfile.$likesHorses))
            ToggleView(title: "Likes cats", binding: viewStore.binding(\.userProfile.$likesCats))
          }

          Group {
            TextInputView(title: "First name", binding: viewStore.binding(\.userProfile.$firstName))
            TextInputView(title: "Last name", binding: viewStore.binding(\.userProfile.$lastName))
            TextInputView(title: "City", binding: viewStore.binding(\.userProfile.$city))
            TextInputView(title: "Twitter", binding: viewStore.binding(\.userProfile.$twitter))
            TextInputView(title: "Github", binding: viewStore.binding(\.userProfile.$github))
            TextInputView(title: "Youtube", binding: viewStore.binding(\.userProfile.$youtube))
            TextInputView(title: "Email", binding: viewStore.binding(\.userProfile.$email))
            TextInputView(title: "Phone", binding: viewStore.binding(\.userProfile.$phone))
            TextInputView(title: "Address", binding: viewStore.binding(\.userProfile.$address))
          }
        }

        Section("Summary") {
          SummaryItemView(label: "Likes giraffes", value: "\(viewStore.userProfile.likesGiraffes)")
          SummaryItemView(label: "Likes horses", value: "\(viewStore.userProfile.likesHorses)")
          SummaryItemView(label: "Likes cats", value: "\(viewStore.userProfile.likesCats)")

          SummaryItemView(label: "First name", value: "\(viewStore.userProfile.firstName)")
          SummaryItemView(label: "Last name", value: "\(viewStore.userProfile.lastName)")
          SummaryItemView(label: "City", value: "\(viewStore.userProfile.city)")
          SummaryItemView(label: "Twitter", value: "\(viewStore.userProfile.twitter)")
          SummaryItemView(label: "Github", value: "\(viewStore.userProfile.github)")
          SummaryItemView(label: "Youtube", value: "\(viewStore.userProfile.youtube)")
        }

      }
    }
  }

}

struct ToggleView: View {
  let title: String
  let binding: Binding<Bool>
  var body: some View {
    HStack {
      Toggle(title, isOn: binding)
    }
  }
}

struct TextInputView: View {
  let title: String
  let binding: Binding<String>

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      TextField(title, text: binding)
        .multilineTextAlignment(.trailing)
    }
  }
}

struct SummaryItemView: View {
  let label: String
  let value: String

  var body: some View {
    HStack {
      Text(label)
        .bold()
      Spacer()
      Text(value)
    }
  }
}
