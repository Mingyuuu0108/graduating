import Foundation

public extension Date {
    
    func parseString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    var remainingTimeText: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: self)
        
        return if let days = components.day, days > 0 {
            "\(days)일"
        } else if let hours = components.hour, let minutes = components.minute {
            "\(hours)시간 \(minutes)분"
        } else {
            "-"
        }
    }
    
    subscript(components: Calendar.Component) -> Int? {
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "ko_KR")
        return calendar.dateComponents([components], from: self).value(for: components)
    }
    
    func equals(_ other: Date, components: Set<Calendar.Component>) -> Bool {
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "ko_KR")
        let selfComponents = calendar.dateComponents(components, from: self)
        let otherComponents = calendar.dateComponents(components, from: other)
        return selfComponents == otherComponents
    }
    
    var weeklyDates: [Date] {
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "ko_KR")
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return (0..<7).compactMap { number in
            if let date = calendar.date(byAdding: .day, value: number, to: startOfWeek) {
                date
            } else {
                nil
            }
        }
    }
    
    var range: Int? {
        let calendar = Calendar.current
        return calendar.range(of: .day, in: .month, for: self)?.count
    }
    
    // 현재 학년을 기준으로 입학일을 구하는 함수
    static func getStartAt(for currentGrade: Int) -> Date? {
        let calendar = Calendar.current
        let now = Date()

        // 현재 연도의 3월 1일 구하기
        var components = calendar.dateComponents([.year], from: now)
        components.month = 3
        components.day = 1
        
        guard calendar.date(from: components) != nil else {
            return nil
        }

        // 현재 학년에 따른 입학 연도 계산
        let admissionYear = components.year! - (currentGrade - 1)

        // 입학 연도의 3월 1일 구하기
        components.year = admissionYear
        return calendar.date(from: components)
    }
    
    func adjustedEndAt(for currentGrade: Int) -> Date? {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        
        guard calendar.date(from: components) != nil else {
            return nil
        }

        let admissionYear = components.year! + 3 - currentGrade
        components.year = admissionYear
        return calendar.date(from: components)
    }
}

public extension DateFormatter {
    convenience init(_ dateFormat: String, locale: Locale = Locale(identifier: "ko_KR")) {
        self.init()
        self.dateFormat = dateFormat
        self.locale = locale
    }
}

func nextFebruaryFirst(from date: Date) -> Date? {
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: date)
    let currentMonth = calendar.component(.month, from: date)
    
    var nextYear = currentYear
    if currentMonth >= 2 {
        nextYear += 1
    }
    
    let februaryFirstComponents = DateComponents(year: nextYear, month: 2, day: 1)
    return calendar.date(from: februaryFirstComponents)
}
