//
//  PDFFormattedView.swift
//  Drivers Log
//
//  Created by Irtaza Fiaz on 19/04/2024.
//

import SwiftUI
import UIKit

struct PDFFormattedView: View {
    
    var trips: [TripItem]
    
    var body: some View {
        
        Button {
            createPDF()
            
        } label: {
            Text("Print Report")
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
                .frame(width: 200)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        
    }
    
    func createPDF() {
        let pageSize = CGSize(width: 612, height: 792)
        let pageRect = CGRect(origin: .zero, size: pageSize)
        let margin = 20.0
        let contentRect = pageRect.insetBy(dx: margin, dy: margin)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let data = renderer.pdfData { ctx in
            
            /// First Page
            ctx.beginPage()
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            let title = "Driver's Log SA"
            title.draw(at: CGPoint(x: margin, y: margin), withAttributes: titleAttributes)
            
            let permitNumber = "Permit# FS5137"
            let permitAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: UIColor.black
            ]
            permitNumber.draw(at: CGPoint(x: pageRect.width - margin - permitNumber.size(withAttributes: permitAttributes).width, y: margin), withAttributes: permitAttributes)
            
            // Drawing a separator line
            let separatorY: CGFloat = 50
            ctx.cgContext.move(to: CGPoint(x: margin, y: separatorY))
            ctx.cgContext.addLine(to: CGPoint(x: pageRect.width - margin, y: separatorY))
            ctx.cgContext.setLineWidth(1.0)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            drawTable(at: CGPoint(x: margin, y: separatorY + 10), in: ctx.cgContext, contentRect: contentRect)
            
            /// Second Page
            ctx.beginPage()
            drawAbbreviations(ctx: ctx, pageRect: pageRect, margin: margin)
            
            /// Third Page
            ctx.beginPage()
            drawSummaryAndDeclarations(ctx: ctx, pageRect: pageRect, margin: margin)
            
        }
        savePDF(data: data)
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
    
    func drawSummaryAndDeclarations(ctx: UIGraphicsPDFRendererContext, pageRect: CGRect, margin: CGFloat) {
        
        
        let dayFilter = { (trip: TripItem) -> Bool in trip.dayOrNight == "Day" }
        let nightFilter = { (trip: TripItem) -> Bool in trip.dayOrNight == "Night" }
        
        let dayStats = totalHoursAndDistance(trips: trips, filter: dayFilter)
        let nightStats = totalHoursAndDistance(trips: trips, filter: nightFilter)
        let totalHours = dayStats.hours + nightStats.hours
        let totalDistance = dayStats.distance + nightStats.distance
        
        let data = [
            ("Day Time", formatHours(dayStats.hours), formatDistance(dayStats.distance)),
            ("Night Time", formatHours(nightStats.hours), formatDistance(nightStats.distance)),
            ("Total", formatHours(totalHours), formatDistance(totalDistance))
        ]
        
        
        let startX = margin
        let startY = margin
        let columnWidth = (pageRect.width - 2 * margin) / 3
        let rowHeight: CGFloat = 20.0
        
        ctx.cgContext.saveGState()
        ctx.cgContext.translateBy(x: startX, y: startY)
        
        let headers = ["Driving Time", "Total Hours", "Total Distance"]
        for (index, header) in headers.enumerated() {
            let frame = CGRect(x: CGFloat(index) * columnWidth, y: 0, width: columnWidth, height: rowHeight)
            ctx.cgContext.setFillColor(UIColor.systemGreen.cgColor)
            ctx.cgContext.fill(frame)
            drawText(header, in: frame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .clear, textColor: .white)
        }
        
        var currentY = rowHeight
        
        for (time, hours, distance) in data {
            let rowItems = [time, hours, distance]
            for (index, text) in rowItems.enumerated() {
                let frame = CGRect(x: CGFloat(index) * columnWidth, y: currentY, width: columnWidth, height: rowHeight)
                ctx.cgContext.setFillColor(UIColor.white.cgColor)
                ctx.cgContext.fill(frame)
                drawText(text, in: frame, withAlignment: .center, fontSize: 10, backgroundColor: .clear)
            }
            currentY += rowHeight
        }
        
        ctx.cgContext.restoreGState()
        
        let declarations = [
            (
                "Declaration by Learner Driver (Compulsory)",
                "I _________________________________________ declare that I have completed 75 hours (4,500 minutes) of driving experience, including atleast 15 hours (900 minutes) of night driving."
            ),
            (
                "Declaration by Qualified Supervising Driver (Optional)",
                "I _________________________________________ declare that I have sighted the 75 hours (4,500 minutes) of driving experience, including atleast 15 hours (900 minutes) of night driving."
            )
        ]
        
        for (title, description) in declarations {
            currentY += rowHeight // Space between entries
            drawDeclaration(ctx: ctx, startX: startX, startY: currentY, pageRect: pageRect, title: title, details: description)
            currentY += 60 // Adjust for the height of the declaration section
        }
        drawSignature(ctx: ctx, startX: startX, startY: currentY, pageRect: pageRect)
    }
    
    
    
    
    func drawDeclaration(ctx: UIGraphicsPDFRendererContext, startX: CGFloat, startY: CGFloat, pageRect: CGRect, title: String, details: String) {
        let margin: CGFloat = 20
        let titleFrame = CGRect(x: startX, y: startY, width: pageRect.width - 2 * margin, height: 20)
        ctx.cgContext.setFillColor(UIColor.systemGreen.cgColor)
        ctx.cgContext.fill(titleFrame)
        drawText(title, in: titleFrame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .clear, textColor: .white)
        
        let detailsFrame = CGRect(x: startX, y: startY + 20, width: pageRect.width - 2 * margin, height: 40)
        drawText(details, in: detailsFrame, withAlignment: .left, fontSize: 10)
    }
    
    func drawSignature(ctx: UIGraphicsPDFRendererContext, startX: CGFloat, startY: CGFloat, pageRect: CGRect) {
        let margin: CGFloat = 20
        let signatureText = "Signature: ________________    Date: ________________"
        let signatureFrame = CGRect(x: startX, y: startY, width: pageRect.width - 2 * margin, height: 20)
        drawText(signatureText, in: signatureFrame, withAlignment: .left, fontSize: 10)
    }
    
    func drawAbbreviations(ctx: UIGraphicsPDFRendererContext, pageRect: CGRect, margin: CGFloat) {
        let startY = margin
        let columnWidths = [100.0, 50.0, 100.0, 50.0, 100.0, 50.0].map { CGFloat($0) }
        let rowHeight: CGFloat = 20.0
        let startX = (pageRect.width - columnWidths.reduce(0, +)) / 2
        
        let headers = ["Road Type", "Abb.", "Weather", "Abb.", "Traffic Density", "Abb."]
        let data = [
            ("Sealed", "S"), ("Wet", "W"), ("Light", "L"),
            ("Unsealed", "U"), ("Dry", "D"), ("Medium", "M"),
            ("Quiet Street", "Q"), ("", ""), ("Heavy", "H")
        ]
        
        ctx.cgContext.saveGState()
        ctx.cgContext.translateBy(x: startX, y: startY)
        
        // Draw headers with background
        for (index, header) in headers.enumerated() {
            let headerFrame = CGRect(x: CGFloat(columnWidths[0..<index].reduce(0, +)), y: 0, width: columnWidths[index], height: rowHeight)
            ctx.cgContext.setFillColor(UIColor.systemGreen.cgColor)
            ctx.cgContext.fill(headerFrame)
            drawText(header, in: headerFrame, withAlignment: .center, fontSize: 10, isBold: true, backgroundColor: .clear, textColor: .white)
        }
        
        // Draw data rows
        var currentY = rowHeight
        for (index, (text, abbreviation)) in data.enumerated() {
            let colIndex = index % 3 * 2
            let textFrame = CGRect(x: CGFloat(columnWidths[0..<colIndex].reduce(0, +)), y: currentY, width: columnWidths[colIndex], height: rowHeight)
            let abbrFrame = CGRect(x: CGFloat(columnWidths[0..<(colIndex + 1)].reduce(0, +)), y: currentY, width: columnWidths[colIndex + 1], height: rowHeight)
            
            // Set background color for rows
            ctx.cgContext.setFillColor(UIColor.lightGray.cgColor)
            ctx.cgContext.fill(textFrame)
            ctx.cgContext.fill(abbrFrame)
            
            // Draw text in the respective cells
            drawText(text, in: textFrame, withAlignment: .left, fontSize: 10, backgroundColor: .clear)
            drawText(abbreviation, in: abbrFrame, withAlignment: .center, fontSize: 10, backgroundColor: .clear)
            
            if (index + 1) % 3 == 0 {
                currentY += rowHeight
            }
        }
        
        ctx.cgContext.restoreGState()
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
    
    func drawTable(at point: CGPoint, in context: CGContext, contentRect: CGRect) {
        let headers = ["Date", "Start", "Finish", "Duration", "Distance", "From", "To", "Road", "Weather", "Traffic"]
        let rowHeight: CGFloat = 20.0
        let columnWidth = (contentRect.width) / CGFloat(headers.count)
        
        context.saveGState()
        context.translateBy(x: point.x, y: point.y)
        
        // Draw header
        for (index, header) in headers.enumerated() {
            let headerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor.white
            ]
            let frame = CGRect(x: CGFloat(index) * columnWidth, y: 0, width: columnWidth, height: rowHeight)
            context.setFillColor(UIColor.systemGreen.cgColor)
            context.fill(frame)
            let textRect = frame.insetBy(dx: 2, dy: 2)
            header.draw(in: textRect, withAttributes: headerAttributes)
        }
        
        // Draw rows dynamically based on trips data
        for (rowIndex, trip) in trips.enumerated() {
            let rowItems = [
                trip.tripDate,
                trip.startTime,
                trip.endTime,
                trip.duration,
                trip.tripTotalDistance,
                trip.startLocation,
                trip.endLocation,
                "Paved",
                "Sunny",
                "Light"
            ]
            
            for (columnIndex, item) in rowItems.enumerated() {
                let itemAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.black
                ]
                let frame = CGRect(x: CGFloat(columnIndex) * columnWidth, y: CGFloat(rowIndex + 1) * rowHeight, width: columnWidth, height: rowHeight)
                context.setFillColor(UIColor.white.cgColor)
                context.fill(frame)
                let textRect = frame.insetBy(dx: 2, dy: 2)
                item.draw(in: textRect, withAttributes: itemAttributes)
            }
        }
        
        context.restoreGState()
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
}
