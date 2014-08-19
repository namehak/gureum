//
//  QwertyKeyboardLayout.swift
//  iOS
//
//  Created by Jeong YunWon on 2014. 8. 6..
//  Copyright (c) 2014년 youknowone.org. All rights reserved.
//

import UIKit

class QwertyKeyboardView: KeyboardView {
    @IBOutlet var shiftButton: GRInputButton!
    @IBOutlet var spaceButton: GRInputButton!

    override init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
}

class QwertyKeyboardLayout: KeyboardLayout {
    var qwertyView: QwertyKeyboardView {
    get {
        return self.view as QwertyKeyboardView
    }
    }

    func keyForPosition(position: GRKeyboardLayoutHelper.Position) -> UnicodeScalar {
        let keylines = ["qwertyuiop", "asdfghjkl", "zxcvbnm", " "]
        let keyline = keylines[position.row].unicodeScalars
        var idx = keyline.startIndex
        for _ in 0..<position.column {
            idx = idx.successor()
        }
        let key = keyline[idx]
        return key
    }

    override class func containerName() -> String {
        return "QwertyLayout"
    }

    override class func loadContext() -> UnsafeMutablePointer<()> {
        return context_create(bypass_phase(), bypass_decoder())
    }

    override func layoutWillLoadForHelper(helper: GRKeyboardLayoutHelper) {

    }

    override func layoutDidLoadForHelper(helper: GRKeyboardLayoutHelper) {
        let theme = preferences.theme
        let map = [
            self.qwertyView.shiftButton!: theme.qwertyShiftCaption,
            self.qwertyView.deleteButton!: theme.qwertyDeleteCaption,
            self.qwertyView.toggleKeyboardButton!: theme.qwerty123Caption,
            self.qwertyView.nextKeyboardButton!: theme.qwertyGlobeCaption,
            self.qwertyView.spaceButton!: theme.qwertySpaceCaption,
            self.qwertyView.doneButton!: theme.qwertyDoneCaption,
        ]
        for (button, captionTheme) in map {
            captionTheme.appeal(button)
        }
    }

    override func insetsForHelper(helper: GRKeyboardLayoutHelper) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1)
    }

    override func numberOfRowsForHelper(helper: GRKeyboardLayoutHelper) -> Int {
        return 4
    }

    override func helper(helper: GRKeyboardLayoutHelper, numberOfColumnsInRow row: Int) -> Int {
        switch row {
        case 0:
            return 10
        case 1:
            return 9
        case 2:
            return 7
        case 3:
            return 0
        default:
            return 0
        }
    }

    override func helper(helper: GRKeyboardLayoutHelper, heightOfRow: Int) -> CGFloat {
        return 54
    }

    override func helper(helper: GRKeyboardLayoutHelper, columnWidthInRow row: Int) -> CGFloat {
        if row == 3 {
            return 160
        } else {
            return 32
        }
    }

    override func helper(helper: GRKeyboardLayoutHelper, leftButtonsForRow row: Int) -> Array<UIButton> {
        switch row {
        case 1:
            return [UIButton(frame: CGRectMake(0, 0, 16, 10))]
        case 2:
            return [self.qwertyView.shiftButton]
        case 3:
            return [self.view.toggleKeyboardButton, self.view.nextKeyboardButton]
        default:
            return []
        }
    }

    override func helper(helper: GRKeyboardLayoutHelper, rightButtonsForRow row: Int) -> Array<UIButton> {
        switch row {
        case 1:
            return [UIButton(frame: CGRectMake(0, 0, 16, 10))]
        case 2:
            return [self.view.deleteButton]
        case 3:
            return [self.qwertyView.spaceButton, self.view.doneButton]
        default:
            return []
        }
    }

    override func helper(helper: GRKeyboardLayoutHelper, buttonForPosition position: GRKeyboardLayoutHelper.Position) -> GRInputButton {
        let button = GRInputButton.buttonWithType(.System) as GRInputButton
        let key =  self.keyForPosition(position)
        button.tag = Int(key.value)
        button.sizeToFit()
        button.addTarget(self.inputViewController, action: "input:", forControlEvents: .TouchUpInside)

        return button
    }

    override func helper(helper: GRKeyboardLayoutHelper, titleForPosition position: GRKeyboardLayoutHelper.Position) -> String {
        let key =  self.keyForPosition(position)
        return "\(Character(UnicodeScalar(key.value - 32)))"
    }

}

class KSX5002KeyboardLayout: QwertyKeyboardLayout {

    override class func loadContext() -> UnsafeMutablePointer<()> {
        return context_create(ksx5002_from_qwerty_phase(), ksx5002_decoder())
    }

    override func helper(helper: GRKeyboardLayoutHelper, buttonForPosition position: GRKeyboardLayoutHelper.Position) -> GRInputButton {
        let keylines = ["qwertyuiop", "asdfghjkl", "zxcvbnm", " "]
        let keyline = keylines[position.row].unicodeScalars
        var idx = keyline.startIndex
        for _ in 0..<position.column {
            idx = idx.successor()
        }
        let key = keyline[idx]

        let button = GRInputButton.buttonWithType(.System) as GRInputButton
        button.tag = Int(key.value)
        button.sizeToFit()
        //button.backgroundColor = UIColor(white: 1.0 - 72.0/255.0, alpha: 1.0)
        button.addTarget(self.inputViewController, action: "input:", forControlEvents: .TouchUpInside)
        
        return button
    }

    override func helper(helper: GRKeyboardLayoutHelper, titleForPosition position: GRKeyboardLayoutHelper.Position) -> String {
        let key = self.keyForPosition(position)
        let label = ksx5002_label(Int8(key.value))
        let text = "\(Character(UnicodeScalar(label)))"
        assert(text != nil)
        return text
    }
    
}
