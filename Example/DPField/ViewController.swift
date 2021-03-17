//
//  ViewController.swift
//  DPField
//
//  Created by Dmitriy Polyakov on 03/16/2021.
//  Copyright (c) 2021 Dmitriy Polyakov. All rights reserved.
//

import UIKit
import DPField

struct TestEncodable: Encodable {
    let testE1: String
    let testE2: Int
}

class TestFieldsForm: FieldsForm {
    let test1: Field<String>
    let test2: Field<Int>
    let test3: Field<TestEncodable>
    
    init(test1: Field<String>, test2: Field<Int>, test3: Field<TestEncodable>) {
        self.test1 = test1
        self.test2 = test2
        self.test3 = test3
        
        super.init()
    }
}

//class TestHandlerList {
//    let handlerist = HandlerList<((Int) -> Void)?>()
//
//    var value: Int = 0 {
//        didSet {
//            self.handlerist.executeHandlers { _, handler in
//                handler?(self.value)
//            }
//        }
//    }
//}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let testHandlerList = TestHandlerList()
//
//        let key1 = testHandlerList.handlerist.appendHandler { value in
//            print("!!! 1:", value)
//        }
//
//        _ = testHandlerList.handlerist.appendHandler { value in
//            print("!!! 2:", value)
//
//            testHandlerList.handlerist.removeHanlderOfKey(key1)
//        }
//
//        _ = testHandlerList.handlerist.appendHandler { value in
//            print("!!! 3:", value)
//        }
//
//        testHandlerList.value += 1
        
        let testForm = TestFieldsForm(test1: .init(validations: .empty, value: "1"), test2: .init(validations: .empty, value: 1), test3: .init(validations: .empty, value: .init(testE1: "testE1", testE2: 2)))
        
        _ = testForm.didChangeFieldValueHanlders.appendHandler { field in
            print("!!!", field?.getValue())
        }
        
        testForm.test1.value = "5657"
//        let testField = Field<Int>.init(validations: .empty, value: 1)
//
//        testField.didSetValueHanlders.appendHandler {  value in
//            print("!!!", value)
//        }
//        testField.value = 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            testForm.test2.value = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600)) {
                testForm.test3.value = TestEncodable(testE1: "7898908", testE2: 67)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

