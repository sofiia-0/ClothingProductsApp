//
//  LoginView.swift
//  ClothingProductsApp
//
//  Created by User-UAM on 1/25/25.
//

import Foundation
import SwiftUI

// Vista para manejar la pantalla de inicio de sesión
struct LoginView: View {
    @State private var username = "" // Almacena el nombre de usuario ingresado
    @State private var password = "" // Almacena la contraseña ingresada
    @State private var showPassword = false // Controla si se muestra la contraseña en texto claro
    @State private var showError = false // Controla la visibilidad del mensaje de error de autenticación
    @Binding var isAuthenticated: Bool // Conexión con la vista principal para controlar el estado de autenticación

    private let predefinedUsername = "Usuario" // Nombre de usuario predefinido para autenticación
    private let predefinedPassword = "123" // Contraseña predefinida para autenticación

    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            // Imagen que aparece en la parte superior de la pantalla
            Image("loginimage") // Asegúrate de que esta imagen exista en los assets
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding(.top, -30)

            // Título principal de la pantalla de inicio de sesión
            Text("Bienvenido")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color(hex: "#606367"))
                .padding(.top, -10)
            
            // Subtítulo adicional debajo del título
            Text("a tu tienda")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#606367"))
                .padding(.top, -20)

            // Descripción de la app
            Text("Aquí podrás registrar los productos de ropa que deseas vender. ¡Comienza ahora a gestionar tu tienda de forma fácil y rápida!")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#606367"))
                .multilineTextAlignment(.center)

            // Campo para ingresar el nombre de usuario
            CustomTextField(placeholder: "Usuario", text: $username)
            
            // Campo para ingresar la contraseña, con opción de mostrar/ocultar
            CustomSecureField(placeholder: "Contraseña", text: $password, showPassword: $showPassword)

            // Botón de login que valida las credenciales
            Button(action: {
                // Verificación de las credenciales
                if username == predefinedUsername && password == predefinedPassword {
                    isAuthenticated = true // Si las credenciales son correctas, cambia el estado de autenticación
                } else {
                    showError = true // Muestra un mensaje de error si las credenciales son incorrectas
                }
            }) {
                Text("Continuar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#a2d8d9"))
                    .cornerRadius(10)
            }
            
            // Muestra un mensaje de error si las credenciales no coinciden
            if showError {
                Text("Usuario o contraseña incorrectos")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
        .background(Color(hex: "#ffffff")) // Fondo blanco para toda la vista
    }
}

// Componente reutilizable para los campos de texto normales
struct CustomTextField: View {
    let placeholder: String // Texto del placeholder
    @Binding var text: String // Vinculación con el texto ingresado

    var body: some View {
        TextField(placeholder, text: $text) // Campo de texto
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.2)) // Fondo gris claro
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1)) // Borde sutil
            .autocapitalization(.none) // Desactiva la autocapitalización
    }
}

// Componente reutilizable para los campos de contraseña
struct CustomSecureField: View {
    let placeholder: String // Texto del placeholder
    @Binding var text: String // Vinculación con la contraseña ingresada
    @Binding var showPassword: Bool // Controla si se debe mostrar la contraseña en texto claro

    var body: some View {
        ZStack(alignment: .trailing) {
            // Si se muestra la contraseña, se usa un campo de texto normal
            if showPassword {
                CustomTextField(placeholder: placeholder, text: $text)
            } else {
                SecureField(placeholder, text: $text) // Campo de texto seguro (oculta los caracteres)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }

            // Botón para alternar entre mostrar y ocultar la contraseña
            Button(action: {
                withAnimation { showPassword.toggle() } // Alterna el estado de showPassword con animación
            }) {
                Image(systemName: showPassword ? "eye.slash" : "eye") // Icono que cambia según el estado
                    .foregroundColor(.gray)
                    .padding(10)
            }
            .padding(.trailing, 7)
        }
    }
}

// Extensión para inicializar colores usando el formato hexadecimal
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var int = UInt64()
        Scanner(string: hexSanitized).scanHexInt64(&int) // Convierte el valor hexadecimal a RGB
        self.init(red: CGFloat((int & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((int & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(int & 0x0000FF) / 255.0)
    }
}
