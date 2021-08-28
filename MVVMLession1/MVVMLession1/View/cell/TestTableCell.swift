//
//  TestTableCell.swift
//  MVVMLession1
//
//  Created by huangweiqiang on 2021/8/27.
//

import UIKit

class TestTableCell: UITableViewCell {
    var titleLab: UILabel = {
        let tempLabel = UILabel.init(frame: CGRect.init())
        tempLabel.backgroundColor = UIColor.clear
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textColor = UIColor.black
        return tempLabel
    }()
    
    var subTitleLab: UILabel = {
        var tempLabel = UILabel.init(frame: CGRect.init())
        tempLabel.backgroundColor = UIColor.clear
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textColor = UIColor.black
        return tempLabel
    }()
    
    var rightBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("follow", for: .normal)
        btn.setTitle("follow", for: .highlighted)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = UIColor.lightGray
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        return btn
    }()
    
    var textField: UITextField = {
        let tempField = UITextField.init()
        tempField.backgroundColor = UIColor.white
        tempField.layer.borderWidth = 1
        tempField.layer.borderColor = UIColor.lightGray.cgColor
        tempField.layer.masksToBounds = true
        return tempField
    }()
    
    var lineView: UIView = {
        let tempView = UIView.init()
        tempView.backgroundColor = UIColor.lightGray
        return tempView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLab)
        contentView.addSubview(subTitleLab)
        contentView.addSubview(rightBtn)
        contentView.addSubview(textField)
        contentView.addSubview(lineView)
        
        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        textField.addTarget(self, action: #selector(self.textValueChange(tf:)), for: UIControl.Event.editingChanged)
        
    }
    
    var cellViewModel: UserTableCellViewModel!
    override func layoutSubviews() {
        titleLab.frame = CGRect.init(x: 10, y: 10, width: 200, height: 20)
        subTitleLab.frame = CGRect.init(x: 10, y: titleLab.frame.maxY, width: 200, height: 20)
        rightBtn.frame = CGRect.init(x: kScreenWidth - 66, y: 10, width: 60, height: 30)
        textField.frame = CGRect.init(x: kScreenWidth - 130, y: 10, width: 50, height: 30)
        lineView.frame = CGRect.init(x: 0, y: 59, width: kScreenWidth, height: 1)
    }
    
    
    ///赋值
    func setUpCellViewModel(vm: UserTableCellViewModel) {
        self.cellViewModel = vm
        self.titleLab.text = vm.name
        cellViewModel.isFollow?.bind({[weak self] flag in
            if flag ?? false {
                self?.rightBtn.setTitle("follow", for: .normal)
                self?.rightBtn.setTitle("follow", for: .highlighted)
                self?.rightBtn.backgroundColor = UIColor.blue
                self?.rightBtn.setTitleColor(.white, for: .normal)
                self?.rightBtn.setTitleColor(.white, for: .highlighted)
                
            }else{
                self?.rightBtn.setTitle("unFollow", for: .normal)
                self?.rightBtn.setTitle("unFollow", for: .highlighted)
                self?.rightBtn.backgroundColor = UIColor.lightGray
                self?.rightBtn.setTitleColor(.black, for: .normal)
                self?.rightBtn.setTitleColor(.black, for: .highlighted)
            }
        })
        
        cellViewModel.inputStr?.bind({[weak self] str in
            self?.textField.text = str
        })
    }
    
        
    ///防止重用
    override func prepareForReuse() {
        self.cellViewModel = nil
        titleLab.text = nil
        subTitleLab.text = nil
        textField.text = nil
    }
        
    ///点击按钮 ---> 调用viewModel中的方法
    @objc private func rightBtnAction(){
        self.cellViewModel?.onPressAtion?()
    }
    
    ///监听textField输入 ---> 调用viewModel中的方法
    @objc func textValueChange(tf: UITextField) {
        self.cellViewModel.inputChange?(tf.text!)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
