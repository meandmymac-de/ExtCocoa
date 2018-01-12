//
//  VibrantWindow.swift
//  ExtCocoa
//
//  Created by Thomas Bonk on 10.01.18.
//  Copyright © 2018 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Cocoa

/**
 @brief This NSWindow subclass provides an interface to enable macOS 10.10 exclusive features
 conveniently. Next to customizing the look of the VibrantWindow content view, you can also
 customize the title bar and standard window buttons (`traffic lights´). The public interface is
 generally similar to INAppStoreWindow to simplify the migration.
 Whenever it makes sense, the properties of your VibrantWindow instance in Interface Builder are
 inspectable.
 
 This is Swift reimplementation of WAYWindow (https://github.com/weAreYeah/WAYWindow).
 */
@IBDesignable
open class VibrantWindow: NSWindow {

    // MARK: - Class Properties
    
    /**
     @brief A flag that determines, if the class supports vibrant appearances.
     Can be used to determine if running on macOS 10.10+
     */
    public static var supportsVibrantAppearances: Bool = {
        return NSClassFromString("NSVisualEffectView") != nil
    }()

    
    // MARK: - Public Properties
    
    /**
     @brief The accessory view controller tha can contain a view to be displayed in the title bar.
     */
    @IBOutlet @objc public dynamic var accessoryViewController: NSTitlebarAccessoryViewController? = nil {
        didSet {
            addTitlebarAccessoryViewController(accessoryViewController!)
        }
    }
    
    /**
     @brief Returns true if the window is currently in full-screen.
     */
    @objc public dynamic var isFullScreen: Bool {
        return
            (self.styleMask.rawValue & NSWindow.StyleMask.fullScreen.rawValue) ==
                NSWindow.StyleMask.fullScreen.rawValue
    }
    
    @IBInspectable @objc public dynamic var contentViewVibrantDarkAppearance: Bool = false {
        didSet {
            if contentViewVibrantDarkAppearance {
                setContentViewMaterial(.dark)
                contentViewVibrantLightAppearance = false
            }
        }
    }
    
    @IBInspectable @objc public dynamic var contentViewVibrantLightAppearance: Bool = false {
        didSet {
            if contentViewVibrantDarkAppearance {
                setContentViewMaterial(.light)
                contentViewVibrantDarkAppearance = false
            }
        }
    }
    
    @IBInspectable @objc public dynamic var vibrantDarkAppearance: Bool = false {
        didSet {
            if vibrantDarkAppearance {
                appearance = NSAppearance(named: .vibrantDark)
                vibrantLightAppearance = false
                aquaAppearance = false
            }
        }
    }
    
    @IBInspectable @objc public dynamic var vibrantLightAppearance: Bool = false {
        didSet {
            if vibrantLightAppearance {
                appearance = NSAppearance(named: .vibrantLight)
                vibrantDarkAppearance = false
                aquaAppearance = false
            }
        }
    }
    
    @IBInspectable @objc public dynamic var aquaAppearance: Bool = true {
        didSet {
            if aquaAppearance {
                appearance = NSAppearance(named: .aqua)
                vibrantLightAppearance = false
                vibrantDarkAppearance = false
            }
        }
    }
    
    
    // MARK: - Initialization
    
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask,
                         backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType,
                   defer: flag)
    }
    
    
    // MARK: - Public Methods
    
    open func replaceSubview(_ view: NSView, withViewOfClass viewClass: NSView.Type) -> NSView? {
        let newView = viewClass.init(frame: view.frame)
        
        replaceSubview(view, withView: newView)
        return newView
    }
    
    open func replaceSubview(_ view: NSView, withView newView: NSView, resizing: Bool = true) {
        let constraints = view.constraints
        
        if resizing {
            newView.frame = view.frame
        }
        
        newView.autoresizesSubviews = view.autoresizesSubviews
        
        view.subviews.forEach { subview in
            let frame = subview.frame
            
            subview.removeFromSuperview()
            newView.addSubview(subview)
            subview.frame = frame
        }
        
        constraints.forEach(newView.addConstraint)
        
        if view.isEqual(to: contentView) {
            contentView = newView
        }
        else {
            view.superview?.replaceSubview(view, with: newView)
        }
        
        self.contentView?.layout()
    }
    
    // MARK: - Private Methods
    
    private func setContentViewMaterial(_ material: NSVisualEffectView.Material) {
        guard VibrantWindow.supportsVibrantAppearances else {
            return
        }
        
        let newContentView = replaceSubview(contentView!,
                                 withViewOfClass: NSVisualEffectView.self) as! NSVisualEffectView
        
        newContentView.material = material
        contentView = newContentView
    }
}
