// Playground - noun: a place where people can play

import Cocoa
import Foundation

class testCell : NSCell {

}

var t : NSCell = testCell()

var q = NSString(CString: class_getName(testCell))
