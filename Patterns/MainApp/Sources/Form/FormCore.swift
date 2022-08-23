//
//  File.swift
//  
//
//  Created by Erik Olsson on 2022-08-19.
//

import ComposableArchitecture
import Common

struct UserProfile: Equatable {
  @BindableState var firstName: String = "Name"
  @BindableState var lastName: String = "Last Name"
  @BindableState var city: String = "city"
  @BindableState var twitter: String = "twitter"
  @BindableState var github: String = "github"
  @BindableState var youtube: String = "youtube"
  @BindableState var email: String = "email"
  @BindableState var phone: String = "phone"
  @BindableState var address: String = "address"
  @BindableState var age: Int = 0
  @BindableState var likesGiraffes: Bool = false
  @BindableState var likesCats: Bool = false
  @BindableState var likesHorses: Bool = false
}

public struct FormState: Equatable {
  var userProfile = UserProfile()

  public init() {}
}

public enum FormAction: BindableAction, Equatable {
  case binding(BindingAction<FormState>)
}

public struct FormEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  public init(mainQueue: AnySchedulerOf<DispatchQueue> = .main) {
    self.mainQueue = mainQueue
  }
}

public let formReducer = Reducer<FormState, FormAction, FormEnvironment> { state, action, env in
  print(action)
  return .none
}
  .binding()

enum DisplayItem: Hashable {
  case string(title: String, keyPath: WritableKeyPath<FormState, BindableState<String>>)
  case bool(title: String, keyPath: WritableKeyPath<FormState, BindableState<Bool>>)
}

extension FormState {
  var displaySections: [SectionWrapper<Int, DisplayItem>] {
    return [
      SectionWrapper(sectionIdentifier: 0,
                     items: [
                      .bool(title: "Likes giraffes", keyPath: \.userProfile.$likesGiraffes),
                      .bool(title: "Likes horses", keyPath: \.userProfile.$likesHorses),
                      .bool(title: "Likes cats", keyPath: \.userProfile.$likesCats),
                      .string(title: "First Name", keyPath: \.userProfile.$firstName),
                      .string(title: "Last Name", keyPath: \.userProfile.$lastName),
                      .string(title: "City", keyPath: \.userProfile.$city),
                      .string(title: "twitter", keyPath: \.userProfile.$twitter),
                      .string(title: "github", keyPath: \.userProfile.$github),
                      .string(title: "youtube", keyPath: \.userProfile.$youtube),
                      .string(title: "email", keyPath: \.userProfile.$email),
                      .string(title: "phone", keyPath: \.userProfile.$phone),
                      .string(title: "address", keyPath: \.userProfile.$address),
                     ])
    ]
  }
}
