//
//  ShareSheet.swift
//  MyXcodeShortcuts
//
//  Created by Brent Michalski on 4/10/24.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ShareSheet>) {
        //
    }

}
