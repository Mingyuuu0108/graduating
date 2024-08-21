import SwiftUI
import MyDesignSystem

struct OnboardingFirstView: View {
    
    @FocusState private var field: Bool
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @EnvironmentObject private var dialogProvider: DialogProvider
    
    var body: some View {
        Group {
            if appState.grade == nil {
                MyTopAppBar.default(title: "학교를 알려주세요 🤔") {
                    content
                }
            } else {
                MyTopAppBar.small(title: "") {
                    content
                }
            }
        }
        .onAppear {
            viewModel.fetchSchools()
        }
    }
    
    private var content: some View {
        VStack(spacing: 12) {
            if appState.grade != nil {
                Text("학교를 알려주세요 🤔")
                    .myFont(.title1B)
                    .foreground(Colors.Label.normal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(spacing: 2) {
                MyTextField("학교 검색", text: $viewModel.searchSchoolName)
                    .focused($field)
                Image(icon: Icons.ETC.Search)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 28, height: 28)
                    .foreground(Colors.Label.alternative)
                    .opacity(0.5)
            }
            .padding(.top, 15)
            if let schools = viewModel.searchedSchools {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(schools, id: \.id) { school in
                            SchoolCell(school: school) {
                                dialogProvider.present(
                                    .init(title: "\(school.name) 학생이 맞으신가요?")
                                    .primaryButton("네, 맞아요") {
                                        appState.school = school
                                        appState.fetchGraduating(id: school.id)
                                        if appState.grade == nil {
                                            router.push(OnboardingDestination.onboardingSecond)
                                        } else {
                                            router.toRoot()
                                        }
                                    }
                                    .secondaryButton("닫기")
                                )
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Colors.Background.neutral)
        .padding(.top, 10)
        .padding(.horizontal, 15)
    }
}

#Preview {
    OnboardingFirstView()
        .registerWanted()
}
