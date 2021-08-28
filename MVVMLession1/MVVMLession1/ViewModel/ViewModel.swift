//
//  ViewModel.swift
//  MVVMLession1
//
//  Created by huangweiqiang on 2021/8/27.
//

import UIKit

struct UserListViewModel {
    var users: Observerable<[UserTableCellViewModel]> = Observerable([])
    init() { }
    
    ///初始化数据， 可以用Service返回，
    func fetchGetData(_ complete: @escaping ([UserTableCellViewModel]) -> Void) {
        var vm: [UserTableCellViewModel] = []
        for kIndex in 0 ..< 50 {
            var vModel = UserTableCellViewModel.init(name: "\(kIndex)")
            vModel.onPressAtion = self.handleAction(vModel: vModel, index: kIndex)
            vModel.inputChange = self.handleChange(vModel: vModel, index: kIndex)
            vm.append(vModel)
        }
        complete(vm)
    }
    
    ///处理点击按钮事件
    func handleAction(vModel: UserTableCellViewModel, index: NSInteger) -> (()->Void) {
        return {
            print("点击\(index)")
            if self.users.value![index].isFollow?.value ?? false {
                self.users.value![index].isFollow?.value = false
            }else{
                self.users.value![index].isFollow?.value = true
            }
        }
    }
    
    ///处理textfield输入事件
    func handleChange(vModel: UserTableCellViewModel, index: NSInteger) -> ((String) -> Void) {
        return { text in
            self.users.value![index].inputStr?.value = text
        }
    }
    
}
