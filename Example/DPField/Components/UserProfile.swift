//
//  UserProfile.swift
//  DPField_Example
//
//  Created by Дмитрий Поляков on 21.03.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import DPField

class UserProfile: FormFields {
    let firstName: TextFieldAdapter
    let lastName: TextFieldAdapter
    let middleName: TextFieldAdapter
    let birthDate: DateFieldAdapter
    
    override init() {
        let maxLength: Int = 16
        let minLength: Int = 8
        
        let nameValidations: DPField.FieldValidations = [
            .minLengthDefault(message: "Min length \(minLength.description) symblos", length: minLength),
            .maxLengthDefault(message: "Max length \(maxLength.description) symblos", length: maxLength)
        ]
        
        self.firstName = .init(validations: nameValidations, value: nil)
        self.lastName = .init(validations: nameValidations, value: nil)
        self.middleName = .init(validations: nameValidations, value: nil)
        self.birthDate = .init(minDate: nil, maxDate: nil, validations: [.isDateDefault(message: "Need birth date")], value: nil)
        
        super.init()
    }
}
