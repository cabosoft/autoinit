//
//  AutoInitModuleListProvider.swift
//  autoinit
//
//  Created by Jim Boyd on 6/12/17.
//

import Foundation

@objc(AutoInitModuleListProvider)
public protocol AutoInitModuleListProvider: NSObjectProtocol {
	var moduleClassList: [AutoInitModule.Type] { get }
}
