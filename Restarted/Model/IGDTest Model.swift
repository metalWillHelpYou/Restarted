//
//  IGDTest Model.swift
//  Restarted
//
//  Created by metalWillHelpYou on 23.11.2024.
//

import Foundation
import SwiftUI

enum LongTestQuestions: LocalizedStringKey, CaseIterable {
    case question1 = "I often lose sleep because of long gaming sessions."
    case question2 = "I never play games in order to feel better."
    case question3 = "I have significantly increased the amount of time I play games over last year."
    case question4 = "When I am not gaming I feel more irritable."
    case question5 = "I have lost interest in other hobbies because of my gaming"
    case question6 = "I would like to cut down my gaming time but it’s difficult to do."
    case question7 = "I usually think about my next gaming session when I am not playing."
    case question8 = "I play games to help me cope with any bad feelings I might have."
    case question9 = "I need to spend increasing amounts of time engaged in playing games."
    case question10 = "I feel sad if I am not able to play games."
    case question11 = "I have lied to my family members because the amount of gaming I do."
    case question12 = "I do not think I could stop gaming."
    case question13 = "I think gaming has become the most time consuming activity in my life"
    case question14 = "I play games to forget about whatever’s bothering me."
    case question15 = "I often think that a whole day is not enough to do everything I need to do in-game."
    case question16 = "I tend to get anxious if I can’t play games for any reason."
    case question17 = "I think my gaming has jeopardized the relationship with my partner."
    case question18 = "I often try to play games less but find I cannot."
    case question19 = "I know my main daily activity has not been negatively affected by my gaming."
    case question20 = "I believe my gaming is negatively impacting on important areas of my life."
}
                                                                                                                                         
enum ShortTestQuestions: LocalizedStringKey, CaseIterable {
    case question1 = "Do you think gaming has become the dominant activity in your daily life?"
    case question2 = "Do you feel more irritability, anxiety or even sadness when you try to either reduce or stop your gaming activity?"
    case question3 = "Do you feel the need to spend increasing amount of time engaged gaming in order to achieve satisfaction or pleasure?"
    case uestion4 = "Do you systematically fail when trying to control or cease your gaming activity?"
    case question5 = "Have you lost interests in previous hobbies and other entertainment activities as a result of your engagement with the game?"
    case question6 = "Have you continued your gaming activity despite knowing it was causing problems between you and other people?"
    case question7 = "Have you deceived any of your family members, therapists or others because the amount of your gaming activity?"
    case question8 = "Do you play in order to temporarily escape or relieve a negative mood (e.g., helplessness, guilt, anxiety)?"
    case question9 = "Have you jeopardized or lost an important relationship, job or an educational or career opportunity because of your gaming activity?"
}

enum LongTestAnswers: LocalizedStringKey, CaseIterable {
    case stronglyDisagree = "Strongly disagree"
    case disagree = "Disagree"
    case neitherAgreeNorDisagree = "Neither agree nor disagree"
    case agree = "Agree"
    case stronglyAgree = "Strongly agree"
}

enum ShortTestAnswers: LocalizedStringKey, CaseIterable {
    case never = "Never"
    case rarely = "Rarely"
    case sometimes = "Sometimes"
    case often = "Often"
    case veryOften = "Very Often"
}

struct TestResult {
    let totalScore: Int
    let conclusion: LocalizedStringKey
}

struct Question {
    let text: String
    let answers: [String]
}

enum TestType {
    case longTest
    case shortTest
}
