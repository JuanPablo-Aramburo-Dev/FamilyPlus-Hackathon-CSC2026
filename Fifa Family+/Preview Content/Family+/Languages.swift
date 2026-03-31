import SwiftUI

struct Languages: View {
    @ObservedObject private var l10n = L10n.shared
    @Environment(\.dismiss) private var dismiss

    private let languages = AppLanguage.allCases

    var body: some View {
        ZStack {
            Color(red: 0.2, green: 0.4, blue: 0.7).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .accessibilityLabel(Text(l10n.t("a11y.back")))
                    }
                    .padding(.leading, 20)

                    Spacer()

                    Text(l10n.t("languages.title"))
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear.frame(width: 44).padding(.trailing, 20)
                }
                .padding(.vertical, 20)

                // Contenedor
                VStack(alignment: .leading, spacing: 0) {

                    Text(l10n.t("languages.info"))
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                        .padding(.bottom, 20)

                    Divider().background(Color.gray.opacity(0.3))

                    Text(l10n.t("languages.section.siteLanguage"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)

                    VStack(spacing: 0) {
                        ForEach(languages, id: \.self) { lang in
                            Button {
                                l10n.setLanguage(lang)
                            } label: {
                                HStack {
                                    Text(lang.displayName)
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                    Spacer()
                                    if l10n.language == lang {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.7))
                                            .imageScale(.large)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    l10n.language == lang
                                    ? Color(red: 0.85, green: 0.9, blue: 0.95)
                                    : Color.white
                                )
                            }
                            .buttonStyle(.plain)

                            if lang != languages.last {
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                                    .padding(.leading, 20)
                            }
                        }
                    }

                    Divider().background(Color.gray.opacity(0.3)).padding(.top, 20)
                }
                .background(Color.white)
                .cornerRadius1(30, corners: [.topLeft, .topRight])
            }
        }
        .navigationBarHidden(true)
    }
}
