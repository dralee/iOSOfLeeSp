//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

for i in 0..<10 {
    print("\(i)", terminator:" ")
}
print()

var sum = 0
for i in 0...10 {
    print("\(i)", terminator:" ")
    sum += i
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = UIColor.red

let btn = UIButton(type: UIButtonType.system)
btn.center = view.center
