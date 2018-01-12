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
    @objc dynamic var isFullScreen: Bool {
        return
            (self.styleMask.rawValue & NSWindow.StyleMask.fullScreen.rawValue) ==
                NSWindow.StyleMask.fullScreen.rawValue
    }
    
    /*- (void) setContentViewAppearanceVibrantDark {
    [self setContentViewAppearance:NSVisualEffectMaterialDark];
    }*/
    
    /*- (void) setContentViewAppearanceVibrantLight {
    [self setContentViewAppearance:NSVisualEffectMaterialLight];
    }
    
    - (void) setContentViewAppearance: (int) material {
    if (![WAYWindow supportsVibrantAppearances])
    return;
    
    NSVisualEffectView *newContentView = (NSVisualEffectView *)[self replaceSubview:self.contentView withViewOfClass:[NSVisualEffectView class]];
    [newContentView setMaterial:material];
    [self setContentView:newContentView];
    }
    
    - (void) setVibrantDarkAppearance {
    [self setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
    }
    
    - (void) setVibrantLightAppearance {
    [self setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantLight]];
    }
    
    - (void) setAquaAppearance {
    [self setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
    }*/
    
    // MARK: - Public Methods
    
    open func replaceSubview(_ view: NSView?, withViewOfClass: NSView.Type) -> NSView? {
        
    }
    
    // MARK: - Private Methods
    
    private func setContentViewMaterial(_ material: NSVisualEffectView.Material) {
        guard VibrantWindow.supportsVibrantAppearances else {
            return
        }
        
        let newContentView = replaceSubview(contentView, withViewOfClass: NSVisualEffectView.self) as! NSVisualEffectView
        
        newContentView.material = material
        contentView = newContentView
    }
}
