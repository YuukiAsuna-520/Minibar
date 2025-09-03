//
//  LoginView.swift
//  Minibar
//
//  Created by 黑白熊 on 3/9/2025.
//

import SwiftUI

/// Minimal login screen with hard validation:
/// - Only accepts exactly 4 digits (e.g., "0808").
/// - Shows a system alert when the input is invalid.
/// - Calls `onLogin(room)` when valid.
struct LoginView: View {
    /// Callback fired on successful validation
    let onLogin: (String) -> Void

    /// Raw user input for room number
    @State private var room = ""

    /// Controls the invalid-input alert presentation
    @State private var showInvalidAlert = false

    var body: some View {
        VStack(spacing: 60) {
            Spacer(minLength: 40)

            Text("Minibar Login")
                .font(.title).bold()

            // Text field for 4-digit room number
            TextField("Room number (e.g. 0808)", text: $room)
                .keyboardType(.numberPad)      // numeric keypad on iPhone
                .textContentType(.oneTimeCode) // helps iOS keep numeric keyboard
                .padding(.horizontal, 12)
                .frame(maxWidth: 340, minHeight: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )

            // Primary action: validate -> alert or continue
            Button("Continue") {
                if isValid(room) {
                    onLogin(room)
                } else {
                    showInvalidAlert = true
                }
            }
            .frame(maxWidth: 340)
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(.horizontal, 24)
        // System alert for invalid input
        .alert("Invalid room number", isPresented: $showInvalidAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enter exactly 4 digits (e.g., 0808).")
        }
    }

    /// Returns true when `s` is exactly 4 digits
    private func isValid(_ s: String) -> Bool {
        s.range(of: #"^\d{4}$"#, options: .regularExpression) != nil
    }
}

#Preview {
    LoginView{ _ in }
}
