# MVVMLession
![image](https://github.com/hwq992689548/MVVMLession/blob/main/Simulator.gif?raw=true )   

IOS  用tableView来了解一下MVVM的入门

### 一、创建工程

写一个简单的tableview和tableviewcell, 有titleLab, textField, button, 如图所示：
再写一个Lession1ViewModel和一个Persion对象，代码如下：

```
struct Persion1 {

    var name:String

    var isFollow:Bool?

    var inputStr:String?

    init(name:String,  isFollow:Bool? =false, inputStr:String? =nil ) {

        self.name= name

        self.isFollow= isFollow

        self.inputStr= inputStr
    }
}
```

```
class Lession1ViewModel {

    var data: [Persion1] = []

    func fetchGetData(completed: @escaping ([Persion1])-> Void) {

        var temp: [Persion1] = []

        for kIndex in 0..<50{

            let vm =Persion1.init(name:"\(kIndex)")

            temp.append(vm)

        }

        completed(temp)

    }

}
```

在viewController中获取数据源的用法：

```
var viewModel = Lession1ViewModel()

 viewModel.fetchGetData{ [weakself] persionListin

            self?.viewModel.data= persionList

            self?.tableView.reloadData()

   }
```

在cell中的赋值： 

```
func setLession1TableCell(model: Persion1) {

        self.dataModel= model

        self.titleLab.text= model.name

        self.textField.text = self.dataModel.inputStr

        if self.dataModel.isFollow??false{

            self.rightBtn.backgroundColor=UIColor.red

        }else{

            self.rightBtn.backgroundColor = UIColor.lightGray

        }

    }
```

还要记得去掉复用

```
//回收处理
    override func prepareForReuse() {
        self.titleLab.text = nil
        self.textField.text = nil
    }

```

ok，第一步算是完成了，接下来进行改造


### 二、对persion进行修改，添加textField和button的响应回调

var onChange: ((String)->Void)?
var onPress: (()->Void)?

```
init(name: String,
         isFollow: Bool? = false,
         inputStr: String? = nil,
         
         onChange: ((String)->Void)? = nil,
         onPress: (()->Void)? = nil
    ) {
        self.name = name
        self.isFollow = isFollow
        self.inputStr = inputStr
        
        self.onChange = onChange
        self.onPress = onPress
    }
```
对Lession1ViewModel进行修改，添加textFiled和button响应回调：

```
class Lession1ViewModel {
    var data: [Persion1] = []
    func fetchGetData(completed: @escaping ([Persion1])-> Void) {
        var temp: [Persion1] = []
        for kIndex in 0 ..< 50 {
            var vm = Persion1.init(name: "\(kIndex)")
            vm.onPress  = self.handleOnPress(vm: vm, index: kIndex)
            vm.onChange = self.handleOnChange(vm: vm, index: kIndex)
            temp.append(vm)
        }
        completed(temp)
    }
    
    func handleOnChange(vm: Persion1, index: NSInteger) -> ((String)->Void) {
        return { text in
            self.data[index].inputStr = text
        }
    }
    
    func handleOnPress(vm: Persion1, index: NSInteger) -> (()->Void) {
        return {
            self.data[index].isFollow = !(self.data[index].isFollow ?? false)
        }
    }
}
```
cell中，对textField和buttong添加事件：

```
	self.textField.addTarget(self, action: #selector(self.onChange(tf:)), for: .editingChanged)
	self.rightBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)

```

```
 @objc func onChange(tf: UITextField) {
    self.dataModel?.onChange?(tf.text!)
  }
    
 @objc func btnAction(){
   	self.dataModel?.onPress?()
 }
```


至此，选成了部分的操作，模拟器上修改textField的值和buggon的点击，只修改到了viewmodel里的数据，没有及时刷新， tableview滑动屏回来时才会刷新数据；  这就需要添加observerable进行订阅监听；

### 三、对persion进行修改：

1、先添加一个Observerable类

```
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

```
2，对persion的输入和点击添加Observerable：

```
var isFollow: Observerable<Bool>?
var inputStr: Observerable<String>?

```

```
   init(name: String,
         isFollow: Observerable<Bool>? = Observerable(false),
         inputStr: Observerable<String>? = Observerable(""),
         
         onChange: ((String)->Void)? = nil,
         onPress: (()->Void)? = nil
    ) {
        self.name = name
        self.isFollow = isFollow
        self.inputStr = inputStr
        
        self.onChange = onChange
        self.onPress = onPress
    }

```

在viewModel和cell中，赋值也随之修改，就是赋值和取值的时候多了一个.value属性，如

```
    func handleOnChange(vm: Persion1, index: NSInteger) -> ((String)->Void) {
        return { text in
            vm.inputStr?.value = text
        }
    }
    
    func handleOnPress(vm: Persion1, index: NSInteger) -> (()->Void) {
        return {
            vm.isFollow?.value = !(vm.isFollow?.value ?? false)
        }
    }
```

在cell中，赋值用绑定的方法：

```
   self.dataModel.inputStr?.bind({ [weak self] str in
        self?.textField.text = str
    })
        
    self.dataModel.isFollow?.bind({[weak self] flag in
      if (flag!) {
          self?.rightBtn.backgroundColor = UIColor.red
       }else{
          self?.rightBtn.backgroundColor = UIColor.lightGray
       }
    })
```

这时修，点击按钮后，会响应handleOnPress，修改viewModel里的isFollow标识，然后会执行bind里的代码，按钮变成红色；



