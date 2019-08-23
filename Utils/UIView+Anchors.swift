import UIKit

extension UIView {

    /// Returns topAnchor from safeAreaLayoutGuide or fallback to regular topAnchor
    public var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }

    /// Returns trailingAnchor from safeAreaLayoutGuide or fallback to regular trailingAnchor
    public var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }

    /// Returns leadingAnchor from safeAreaLayoutGuide or fallback to regular leadingAnchor
    public var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }

    /// Returns bottomAnchor from safeAreaLayoutGuide or fallback to regular bottomAnchor
    public var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }

    /// Add or update side constraints. Depending on the horizontal size class
    ///  this will use safeAreaLayoutGuide or readableContentGuide
    public func constraintToSideAnchors(usingReadableContentGuide readableContentGuide: Bool = true) {
        guard let view = superview else { return }

        // Remove side constraints
        let sideConstraints = view.constraints
            .filter({ $0.firstAnchor == self.leadingAnchor || $0.firstAnchor == self.trailingAnchor })
        view.removeConstraints(sideConstraints)

        var leadingAnchor: NSLayoutXAxisAnchor
        var trailingAnchor: NSLayoutXAxisAnchor

        if self.traitCollection.horizontalSizeClass == .compact || readableContentGuide == false {
            leadingAnchor = view.safeLeadingAnchor
            trailingAnchor = view.safeTrailingAnchor
        } else {
            leadingAnchor = view.readableContentGuide.leadingAnchor
            trailingAnchor = view.readableContentGuide.trailingAnchor
        }

        view.addConstraints([
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
            ])
    }
}

// MARK: Anchors sugar
extension UIView {

    /// adds the subview in the view and make it fit in its superView with constraints
    ///
    /// - Parameters:
    ///   - subView:  subview you want to add in the view
    ///   - margin: margin when adding the view
    public func addSubviewAndFit(_ subView: UIView, margin: CGFloat = 0) {
        addSubview(subView)
        subView.didMoveToSuperview()

        subView.anchor(top: topAnchor, topConstant: margin,
                       bottom: bottomAnchor, bottomConstant: margin,
                       leading: leadingAnchor, leadingConstant: margin,
                       trailing: trailingAnchor, trailingConstant: margin)
    }

    /// adds the subview in the view and make it fit in its superView with constraints
    ///
    /// - Parameter subView: subview you want to add in the view
    public func addSubviewAndFit(_ subView: UIView, insets: UIEdgeInsets) {
        addSubview(subView)
        subView.didMoveToSuperview()

        subView.anchor(top: topAnchor, topConstant: insets.top,
                       bottom: bottomAnchor, bottomConstant: insets.bottom,
                       leading: leadingAnchor, leadingConstant: insets.left,
                       trailing: trailingAnchor, trailingConstant: insets.right)
    }

    /// Syntaxic sugar to create NSLayout anchors.
    /// This method calls translatesAutoresizingMaskIntoConstraints = false and create the anchors with values
    ///
    /// One example of use could be :
    ///
    ///     // this would create anchors between myView and the current view.
    ///     myView.anchor(top: view.topAnchor,
    ///     leading: view.leadingAnchor,
    ///     trailing: view.trailingAnchor)
    ///
    /// - Parameters:
    /// - bottomConstant: - constant compared to the one you would create with a classic anchor
    /// - rightConstant: - constant (same as bottmConstant)
    /// - width: width anchor constant
    /// - height: heigh anchor constant
    /// - activated: should the function activate the anchors, select no if you want a personalized priority for instance
    /// - Returns: created anchors
    @discardableResult
    public func anchor(top: NSLayoutYAxisAnchor? = nil, topConstant: CGFloat = 0,
                                          bottom: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat = 0,
                                          leading: NSLayoutXAxisAnchor? = nil, leadingConstant: CGFloat = 0,
                                          trailing: NSLayoutXAxisAnchor? = nil, trailingConstant: CGFloat = 0,
                                          width: CGFloat = 0, height: CGFloat = 0, activated: Bool = true) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let leading = leading {
            anchors.append(leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
        }

        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let trailing = trailing {
            anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
        }

        if width > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }

        if height > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }

        anchors.forEach { $0.isActive = activated }

        return anchors
    }

    /// Anchors the view to a given view, if no view is given it will be anchored to its superview
    ///
    /// - Parameter view: view to anchor to, default: superview
    public func anchorCenterX(to view: UIView? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let view = view {
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            return
        } else if let superview = self.superview {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        }
    }

    /// Anchors the view to a given view, if no view is given it will be anchored to its superview
    ///
    /// - Parameter view: view to anchor to, default: superview
    public func anchorCenterY(to view: UIView? = nil) {
        translatesAutoresizingMaskIntoConstraints = false

        if let view = view {
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            return
        } else if let superview = self.superview {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
    }

    /// Anchors the view to a given view, if no view is given it will be anchored to its superview
    ///
    /// - Parameter view: view to anchor to, default: superview
    public func anchorCenter(to view: UIView? = nil) {
        anchorCenterX(to: view)
        anchorCenterY(to: view)
    }
}
