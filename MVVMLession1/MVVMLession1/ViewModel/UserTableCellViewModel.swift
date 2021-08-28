//
//  UserTableCellViewModel.swift
//  MVVMLession1
//
//  Created by huangweiqiang on 2021/8/28.
//

import UIKit

///tablecell 的modelView
struct UserTableCellViewModel {
    let name: String
    let subName: String?
    var isFollow: Observerable<Bool>?
    var onPressAtion: (()-> Void)?
    var inputStr: Observerable<String>?
    var inputChange: ((String) -> Void)?
    init(name: String,
         subName: String? = nil,
         isFollow: Observerable<Bool>? = Observerable(false),
         onPressAtion: (()->Void)? = nil,
         inputStr: Observerable<String>? = Observerable(""),
         inputChange: ((String)->Void)? = nil
    ) {
        self.name = name
        self.subName = subName
        self.isFollow = isFollow
        self.onPressAtion = onPressAtion
        self.inputStr = inputStr
        self.inputChange = inputChange
    }
}

///监听操作
class Observerable<T> {
    var value: T? {
        didSet {
            listener?(self.value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    
    var listener: ((T?)-> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        self.listener = listener
        listener(value)
    }
}
