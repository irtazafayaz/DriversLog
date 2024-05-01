//
//  PDF+Extension.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 01/05/2024.
//

import SwiftUI
import UIKit

extension PDFFormattedView {
    
    func drawDeclaration(ctx: UIGraphicsPDFRendererContext, startX: CGFloat, startY: CGFloat, pageRect: CGRect, title: String, details: String) {
        let margin: CGFloat = 20
        let titleFrame = CGRect(x: startX, y: startY, width: pageRect.width - 2 * margin, height: 20)
        ctx.cgContext.setFillColor(UIColor.systemGreen.cgColor)
        ctx.cgContext.fill(titleFrame)
        drawText(title, in: titleFrame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .clear, textColor: .black)
        
        let detailsFrame = CGRect(x: startX, y: startY + 20, width: pageRect.width - 2 * margin, height: 40)
        ctx.cgContext.setFillColor(UIColor.systemGreen.cgColor)
        ctx.cgContext.fill(detailsFrame)
        drawText(details, in: detailsFrame, withAlignment: .left, fontSize: 10, backgroundColor: .clear)

        // Add signature section directly below the details section
        let signatureStartY = startY + 60
        drawSignature(ctx: ctx, startX: startX, startY: signatureStartY, pageRect: pageRect)
    }

    func drawSignature(ctx: UIGraphicsPDFRendererContext, startX: CGFloat, startY: CGFloat, pageRect: CGRect) {
        let margin: CGFloat = 20
        let signatureText = "Signature: ________________    Date: ________________"
        let signatureFrame = CGRect(x: startX, y: startY, width: pageRect.width - 2 * margin, height: 20)
        ctx.cgContext.setFillColor(UIColor.systemGreen.cgColor)
        ctx.cgContext.fill(signatureFrame)

        drawText(signatureText, in: signatureFrame, withAlignment: .left, fontSize: 10, backgroundColor: .systemGreen)
    }


    
    func drawText(_ text: String, in rect: CGRect, withAlignment alignment: NSTextAlignment, fontSize: CGFloat, isBold: Bool = false, backgroundColor: UIColor = .white, textColor: UIColor = .black) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .font: isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: textColor,
            .backgroundColor: backgroundColor
        ]
        text.draw(in: rect, withAttributes: attributes)
    }
    

    
    
    func savePDF(data: Data) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pdfPath = documentDirectory.appendingPathComponent("DayTimeLog2page.pdf")
            do {
                try data.write(to: pdfPath)
                print("PDF created at: \(pdfPath)")
                sharePDF(pdfPath: pdfPath)
            } catch {
                print("Could not save PDF: \(error)")
            }
        }
    }
    
    func sharePDF(pdfPath: URL) {
        let activityViewController = UIActivityViewController(activityItems: [pdfPath], applicationActivities: nil)
        
        // Presenting the share sheet
        if let topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            // Ensures that iPad doesn't crash on attempting to present a full screen VC in a popover
            activityViewController.popoverPresentationController?.sourceView = topController.view
            
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func totalHoursAndDistance(trips: [TripItem], filter: (TripItem) -> Bool) -> (hours: Double, distance: Double) {
        var totalHours = 0.0000
        var totalDistance = 0.0000

        for trip in trips.filter(filter) {
            // Parse duration string "HH:mm:ss" to calculate total hours
            let durationComponents = trip.duration.split(separator: ":").map { Double($0) ?? 0.0 }
            if durationComponents.count == 3 {
                let hours = durationComponents[0]
                let minutes = durationComponents[1] / 60
                let seconds = durationComponents[2] / 3600
                totalHours += hours + minutes + seconds
            }

            // Use the distance directly as it's assumed to be in kilometers
            if let distance = Double(trip.tripTotalDistance) {
                totalDistance += distance
            }
        }

        return (totalHours, totalDistance)
    }

    func formatHours(_ hours: Double) -> String {
        return String(format: "%.2fh", hours)
    }

    func formatDistance(_ distance: Double) -> String {
        return String(format: "%.2fkm", distance)
    }
    
}
