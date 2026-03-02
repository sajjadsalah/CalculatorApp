import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var firstNumber: Double = 0
    @State private var operation = ""
    @State private var isNewInput = true
    
    let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 12) {
                Spacer()
                
                HStack {
                    Spacer()
                    Text(display)
                        .font(.system(size: display.count > 9 ? 40 : 70, weight: .light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal, 20)
                }
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { btn in
                            Button(action: { handleButton(btn) }) {
                                Text(btn)
                                    .font(.system(size: 30, weight: .medium))
                                    .frame(width: btn == "0" ? 170 : 80, height: 80)
                                    .background(btnColor(btn))
                                    .foregroundColor(btnTextColor(btn))
                                    .cornerRadius(40)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    func btnColor(_ btn: String) -> Color {
        if ["÷", "×", "-", "+", "="].contains(btn) { return .orange }
        if ["AC", "+/-", "%"].contains(btn) { return Color(.lightGray) }
        return Color(white: 0.2)
    }
    
    func btnTextColor(_ btn: String) -> Color {
        if ["AC", "+/-", "%"].contains(btn) { return .black }
        return .white
    }
    
    func handleButton(_ btn: String) {
        switch btn {
        case "AC":
            display = "0"; firstNumber = 0; operation = ""; isNewInput = true
        case "+/-":
            if let val = Double(display) { display = formatNumber(-val) }
        case "%":
            if let val = Double(display) { display = formatNumber(val / 100) }
        case "÷", "×", "-", "+":
            firstNumber = Double(display) ?? 0
            operation = btn; isNewInput = true
        case "=":
            let second = Double(display) ?? 0
            var result: Double = 0
            switch operation {
            case "÷": result = second != 0 ? firstNumber / second : 0
            case "×": result = firstNumber * second
            case "-": result = firstNumber - second
            case "+": result = firstNumber + second
            default: return
            }
            display = formatNumber(result); isNewInput = true
        case ".":
            if isNewInput { display = "0."; isNewInput = false }
            else if !display.contains(".") { display += "." }
        default:
            if isNewInput { display = btn; isNewInput = false }
            else { display = display == "0" ? btn : display + btn }
        }
    }
    
    func formatNumber(_ num: Double) -> String {
        if num == num.rounded() && !num.isInfinite {
            return String(Int(num))
        }
        return String(num)
    }
}

#Preview {
    ContentView()
}
