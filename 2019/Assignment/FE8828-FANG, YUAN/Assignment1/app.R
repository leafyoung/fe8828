library(shiny)
ui <- fluidPage(navbarPage(
  "Safeguard Reinsurance",
  tabPanel(
    "Our Group",
    fluidRow(
      column(
        6,
        h1("ABOUT US"),
        br(),
        "Safeguard, the largest reinsurer in the region, provides insurance companies with a diversified and
         innovative range of solutions and services to control and manage risk. Using its experience and expertise,
         Safeguard provides cutting-edge financial solutions, analytics tools and services in all areas related to
         risk – in Life & Health insurance (longevity, mortality, LTC, etc.) as well as in P&C insurance (natural
         catastrophes, agriculture, industry, transport, engineering, etc.)."
      ),
      column(6, img(
        src = "Reinsurance.png",
        height = "100%",
        width = "100%"
      ))
    ),
    br(),
    br(),
    sidebarLayout(
      position = "left",
      sidebarPanel(h3("Our History"), width = 3, align = 'center'),
      mainPanel(
        "Founded in 1999, Safeguard was created
         in the aftermath of 1997 Asian Financial crisis and has been expanding
         its business across the region ever since."
      )
    )
    ,
    sidebarLayout(
      position = "left",
      sidebarPanel(h3("Our Value"), width = 3, align = 'center'),
      mainPanel(
        "Safeguard’s corporate values are at the heart of its activity.
         The Group is constantly striving to build a sustainable company that strikes the
         right balance between its own legitimate interests and those of the common good."
      )
    ),
    sidebarLayout(
      position = "left",
      sidebarPanel(h3("Our Global Presence"), width = 3, align = 'center'),
      mainPanel(
        "With 38 offices and 2000 employers in the region, Safeguard is
         currently the largest reinsurer in the region and is aiming for a bigger share of the
         global market."
      )
    )
  ),
  
  tabPanel(
    "Our Expertise",
    titlePanel(h1("THE ART & SCIENCE OF RISK")),
    br(),
    br(),
    fluidRow(title = "Our Solutions",
             column(
               4,
               wellPanel(
                 h3("Reinsurance is a knowledge industry"),
                 "The reinsurance industry is all about combining technical
                  expertise and experience with the developments of science.
                  However many tools we use to conduct our activities (models,
                  databases, pricing tools, reserving tools, and so on), we
                  also need expert judgments and human experience to correctly
                  underwrite. This is what we call the art of underwriting.
                  Reinsurance is a knowledge industry. Expertise is an accumulation
                  variable."
               )
             ),
             column(8,
                    wellPanel(
                      h3("Science is at the heart of Safeguard’s DNA"),
                      fluidRow(column(
                        6,
                        wellPanel(
                          h4("Controlling risks"),
                          "To better control both its own risks and those of its clients,
                           the Group has developed a number of initiatives. One ambitious project has culminated
                           in the creation of Safeguard’s own internal risk management model. The Group has also notably
                           created an original tool for the assessment of risk interdependence, called ProbEx."
                        )
                      ),
                      column(
                        6,
                        wellPanel(
                          h4("Promoting science"),
                          "Safeguard also helps to promote and disseminate science.The Safeguard
                           Corporate Foundation for Science, steered by an independent Scientific
                           Board, supports ambitious research projects. The Safeguard Actuarial
                           Awards bear witness to the Group’s commitment to the promotion of actuarial
                           science.You can read more about the Actuarial Awards here."
                        )
                      ))
                    )))
  ),
  tabPanel(
    "Our Solutions",
    navlistPanel(
      "Life & Health",
      tabPanel(
        "Our Mission",
        h1("Our Mission — Life & Health"),
        br(),
        "The Life & Health division of the Group ranks among the top four Life reinsurers
         in the world. Its expert teams have been providing worldwide clients with superior
         reinsurance products and services for over 20 years and its strategy is based on
         the development of long-term relationships with its clients throughout the world.
         By providing solutions to address Life insurers' financial and risk management needs
         and thus contributing to the success of their business, the Life division endeavors
         to be its clients' Life reinsurer of choice.",
        br(),
        br(),
        img(
          src = "Life & Health.png",
          height = "100%",
          width = "100%"
        )
        
      ),
      tabPanel(
        "Our Solutions",
        h1("Our Solutions — Life & Health"),
        br(),
        h3("RISK SOLUTIONS"),
        "Safeguard’s Risk Solutions product line is a recognized leader in addressing biometric
         risks. It helps clients to mitigate claims volatility, covering all Protection
         insurance products. In addition to its core Life expertise, the Risk Solutions
         team leverages a unique set of capabilities to support clients with a broad range
         of products including Disability, Critical Illness, Long-Term Care, Personal
         Accident & Medical, and Credit products for both individuals and groups.",
        h3("FINANCIAL AND LONGEVITY SOLUTIONS"),
        "The Global Financial and Longevity Solutions product line helps clients to manage
         their solvency and cash needs. This team works closely with Safeguard’s local market
         teams, leveraging on deep market understanding and client franchise. Financial
         Solutions provides liquidity, balance sheet and income statement benefits to clients.
         Longevity products cover the risk of negative deviation from expected results due
         to the insured or annuitant living longer than assumed in the pricing of the cover
         provided by insurers or pension funds.",
        h3("DISTRIBUTION SOLUTIONS"),
        "Safeguard’s Global Distribution Solution (GDS) product line
         supports clients with an unparalleled understanding of the insurance industry, coupled
         with deep consumer insights to develop and support distribution strategies that align
         internal operating effectiveness with superior customer experiences. Operating business
         models from business to business (B2B), business to business to consumer (B2B2C) and
         direct to consumer (D2C), GDS distribution, marketing, underwriting, product and claims
         solutions are all supported by market-leading technology enablers, data analytics and
         financing solutions. A diverse range of market segments are supported, including Bancassurance,
         traditional Life and Health, Takaful, Banking and Affinity groups."
      ),
      "P & C",
      tabPanel(
        "Our Mission",
        h1("Our Mission — P & C"),
        br(),
        "Providing proportional and non-proportional reinsurance in many forms, Safeguard’s P&C experts stand
        out thanks to their spirit of long-term partnership. Their aim is to evolve alongside their clients,
        while ensuring a consistent underwriting philosophy and direct access to decision makers.We strive:
        to be one of the preferred P&C partners for our clients, leading business and providing a full range
        of solutions, both locally and globally to be a good corporate citizen to do all this while maintaining
        an efficient and proven shock-absorbing capacity and producing best-in-class results.",
        br(),
        br(),
        img(
          src = "P & C.png",
          height = "100%",
          width = "100%"
        )
      ),
      tabPanel(
        "Our Solutions",
        h1("Our Solutions — P & C"),
        br(),
        "Our Treaty P&C teams provide proportional and non-proportional reinsurance in many forms across Property
        and Casualty Treaties: Property treaties: covering damage to underlying assets and direct or contingent
        business interruption losses caused by fire or other perils, including natural catastrophes Motor: covering
        original risks of motor property damage and bodily injury Casualty treaties: covering general liability,
        product liability and professional indemnity Our underwriting of Treaty P&C business relies on decentralized
        underwriting teams with an in-depth understanding of local conditions, trends and market needs. It is based
        on three geographic, market-specific areas: Europe, Middle East and Africa (EMEA), Americas and Asia-Pacific."
      )
    )
  )
  
  ,
  br(),
  br(),
  p(
    "Address: 888 Nanyang Crescent, Singapore",
    br(),
    "Telephone: +65 88888888",
    br(),
    "Email: reinsurance@safeguard.com" ,
    align = 'center'
  )
))

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)