//
//  AutoInitModule.swift
//  autoinit
//
//  Created by Jim Boyd on 6/6/17.
//

import Foundation


@objc public protocol AutoInitModule: class {
	static func initializeModule()
	@objc optional static func moduleDependencies() -> [AutoInitModule.Type]
	@objc optional static func destructModule()
}

