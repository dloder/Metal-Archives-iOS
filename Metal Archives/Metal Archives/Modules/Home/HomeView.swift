//
//  HomeView.swift
//  Metal Archives
//
//  Created by Thanh-Nhon Nguyen on 19/06/2021.
//

import SwiftUI

// swiftlint:disable line_length
struct HomeView: View {
    @EnvironmentObject private var settings: Preferences
    let apiService: APIServiceProtocol

    var body: some View {
        Form {
            NavigationLink(destination: {
                BandView(apiService: apiService,
                         bandUrlString: "https://www.metal-archives.com/bands/Death/141")
            }, label: {
                Text("Death")
            })

            NavigationLink(destination: {
                BandView(apiService: apiService,
                         bandUrlString: "https://www.metal-archives.com/bands/Testament/70")
            }, label: {
                Text("Testament")
            })

            NavigationLink(destination: {
                BandView(apiService: apiService,
                         bandUrlString: "https://www.metal-archives.com/bands/Lamb_of_God/59")
            }, label: {
                Text("Lamb of God")
            })

            NavigationLink(destination: {
                BandView(apiService: apiService,
                         bandUrlString: "https://www.metal-archives.com/bands/Nile/139")
            }, label: {
                Text("Nile")
            })

            NavigationLink(destination: {
                BandView(apiService: apiService,
                         bandUrlString: "https://www.metal-archives.com/bands/Fleshgod_Apocalypse/113185")
            }, label: {
                Text("Fleshgod Apocalypse")
            })

            NavigationLink(destination: {
                BandView(apiService: apiService,
                         bandUrlString: "https://www.metal-archives.com/bands/Cephalic_Destruction/3540495596")
            }, label: {
                Text("Cephalic Destruction")
            })

            NavigationLink(destination: {
                BandView(apiService: apiService,
                         bandUrlString: "https://www.metal-archives.com/bands/Earthwhore/110516")
            }, label: {
                Text("Earthwhore")
            })

            NavigationLink(destination: {
                ReleaseView(apiService: apiService,
                            urlString: "https://www.metal-archives.com/albums/Death/Scream_Bloody_Gore/598",
                            parentRelease: nil)
            }, label: {
                Text("Scream Bloody Gore")
            })

            Group {
                NavigationLink(destination: {
                    ReleaseView(apiService: apiService,
                                urlString: "https://www.metal-archives.com/albums/Death/Ultimate_Revenge_2/254112",
                                parentRelease: nil)
                }, label: {
                    Text("Ultimate Revenge 2")
                })

                NavigationLink(destination: {
                    ReleaseView(apiService: apiService,
                                urlString: "https://www.metal-archives.com/albums/Death/Victims_of_Death_-_The_Best_of_Decade_of_Chaos/665400",
                                parentRelease: nil)
                }, label: {
                    Text("Victims of Death - The Best of Decade of Chaos")
                })

                NavigationLink(destination: {
                    ReleaseView(apiService: apiService,
                                urlString: "https://www.metal-archives.com/albums/At_Radogost%27s_Gates/Dyau/57765",
                                parentRelease: nil)
                }, label: {
                    Text("Dyau")
                })

                NavigationLink(destination: {
                    ArtistView(apiService: apiService,
                               urlString: "https://www.metal-archives.com/artists/Chuck_Schuldiner/3012")
                }, label: {
                    Text("Chuck Schuldiner")
                })

                NavigationLink(destination: {
                    LabelView(apiService: apiService,
                              urlString: "https://www.metal-archives.com/labels/Nuclear_Blast/2")
                }, label: {
                    Text("Nuclear Blast")
                })

                NavigationLink(destination: {
                    LabelView(apiService: apiService,
                              urlString: "https://www.metal-archives.com/labels/Anstalt_Records/4867")
                }, label: {
                    Text("Anstalt Records")
                })

                NavigationLink(destination: {
                    ReviewView(apiService: apiService,
                               urlString: "https://www.metal-archives.com/reviews/Death/Live_Tape_%232/67218/AgnosticPuppy666/799050")
                }, label: {
                    Text("Live Tape #2")
                })

                NavigationLink(destination: {
                    ReviewView(apiService: apiService,
                               urlString: "https://www.metal-archives.com/reviews/Death/Individual_Thought_Patterns/613/robotiq/126459")
                }, label: {
                    Text("Individual Thought Patterns")
                })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(apiService: APIService())
            .environment(\.colorScheme, .dark)
            .environmentObject(Preferences())
    }
}
