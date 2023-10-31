ui <- fluidPage(
  ## Enable js
  shinyjs::useShinyjs(),
  shinyjs::inlineCSS(mandatory_star_css),
  ## Theme
  theme = bs_theme(
    bootswatch = "flatly",
    heading_font = font_google("Roboto"),
    base_font = font_google("Roboto"),
    code_font = font_google("JetBrains Mono")
  ),
  tags$style(HTML("body {line-height: 1.75}")),
  navbarPage(
    ## Clicking title will point to the home tab
    ## Hide home tab; a nav title will serve as a home tab
    header = tags$style(HTML(
      ".container-fluid > .nav > li > a[data-value='Home'] {display: none}
                              #title {color:white; text-decoration: none}
                              #title:hover {color: #18bc9c}
                              #title:focus {color: #18bc9c}"
    )),
    title = actionLink("title", "AKR Superfamily", icon = icon("home")),
    id = "main",
    tabPanel(
      "Home",
      includeMarkdown("text/home.md")
    ),
    navbarMenu(
      "About AKR",
      tabPanel(
        "Nomenclature",
        includeMarkdown("text/aboutAKR_nomenclature.md")
      ),
      tabPanel(
        "Protein Structures",
        includeMarkdown("text/aboutAKR_protein.md")
      ),
      tabPanel(
        "Families",
        includeMarkdown("text/aboutAKR_families.md")
      )
    ),
    navbarMenu(
      "AKR Members",
      tabPanel(
        "Existing members",
        includeMarkdown("text/members_existing.md"),
        hr(),
        DT::dataTableOutput("existing"),
        p(tags$sup(1),
          " Where no reference is given please refer to the ",
          "accession number in the appropriate database",
          br(),
          tags$sup(2),
          " Trichosporonoides megachilieni, as known as Moniliella ",
          "megachiliensis",
          style = "font-size: 0.85em")
      ),
      tabPanel(
        "Potential members",
        includeMarkdown("text/members_potential.md"),
        hr(),
        DT::dataTableOutput("potential")
      ),
      tabPanel(
        "Grouped by PDB Structure",
        includeMarkdown("text/members_pdb.md"),
        hr(),
        DT::dataTableOutput("pdb")
      )
    ),
    tabPanel(
      "Phylogenies",
      includeMarkdown("text/phylogenies.md"),
      selectInput(
        "Phylogeny",
        label = "Select an AKR Phylogeny Diagram",
        choices = list(
          ` ` = list(
            "Overview", "AKR1", "AKR2", "AKR3", "AKR4", "AKR5", "AKR6", "AKR7",
            "AKR9", "AKR11", "AKR12", "AKR13"
          ),
          `Taxonomic group` = list(
            "Animalia", "Bacteria", "Fungi", "Plantae",
            "Insecta", "Mammalia",
            "Lagomorpha", "Rodentia",
            "Homo sapiens"
          )
        ),
        selected = "Overview"),
      uiOutput("AKR_trees")
    ),
    tabPanel(
      "Multiple Sequence Alignment",
      includeMarkdown("text/msa.md"),
      selectInput(
        "msa_dropdown",
        label = NULL,
        ## choice = akr_msa_files
        choice = list(
          ` ` = akr_msa_by_fam,
          `Taxonomic group` = akr_msa_by_taxonomy
        )
      ),
      msaROutput("msa_viewer", width = "100%")
    ),
    tabPanel(
      "Submit AKR Sequences",
      tabsetPanel(
        tabPanel(
          "Instructions",
          linebreaks(1),
          includeMarkdown("text/submission_instructions.md")
        ),
        tabPanel(
          "Submit a new AKR sequence",
          linebreaks(1),
          div(
            id = "form",
            textInput("name", mandatory_star("Name"), placeholder = "Your first and last name"),
            splitLayout(
              textInput("email", mandatory_star("Email"), placeholder = "example@example.com"),
              textInput("phone", mandatory_star("Phone"), placeholder = "###-###-####"),
              cellWidths = 350,
              cellArgs = list(style = "padding-right: 50px")
            ),
            textInput("address1", mandatory_star("Street Address"), width = 654),
            textInput("address2", "Address Line 2", width = 654),
            splitLayout(
              textInput("city", mandatory_star("City")),
              textInput("state", "State/Province/Region"),
              cellWidths = 350,
              cellArgs = list(style = "padding-right: 50px")
            ),
            splitLayout(
              textInput("zipcode", mandatory_star("Postal/Zip Code")),
              textInput("country", mandatory_star("Country")),
              cellWidths = 350,
              cellArgs = list(style = "padding-right: 50px")
            ),
            textInput(
              "trivial_name",
              mandatory_star("Trivial name if one has been assigned (if none, state None)"),
              placeholder = "None", width = 654
            ),
            radioButtons(
              "protein_expressed",
              mandatory_star("Has the protein been expressed?"),
              choices = c("Yes", "No"),
              selected = character(0)
            ),
            textAreaInput(
              "protein_function",
              mandatory_star("What function has been assigned to the protein?"),
              width = 654, height = 150
            ),
            textAreaInput(
              "protein_sequence",
              mandatory_star("Sequence of the protein"),
              width = 654, height = 150
            ),
            splitLayout(
              textInput("origin", mandatory_star("Species of origin")),
              textInput("expression_system", mandatory_star("Expression system used")),
              cellWidths = 350,
              cellArgs = list(style = "padding-right: 50px")
            ),
            textInput(
              "substrate",
              mandatory_star("Substrate used to assign enzyme activity"),
              width = 654
            ),
            splitLayout(
              textInput("accession", mandatory_star("Accession Number")),
              textInput("pub_status", mandatory_star("Status of Publication")),
              cellWidths = 350,
              cellArgs = list(style = "padding-right: 50px")
            ),
            textInput(
              "citation", mandatory_star("Citation, if one exists (if none, state None)"),
              placeholder = "None", width = 654
            ),
            div(
              actionButton("submit", "Submit", class = "btn-primary"),
              ## style = "margin-top: 25px; display: flex; justify-content: center"
              style = "padding-top: 20px; padding-bottom: 10px; padding-left: 580px"
            )
          ),
          shinyjs::hidden(
            div(
              id = "thankyou_msg",
              h4("Thanks, a new AKR sequence was submitted successfully!"),
              actionLink("submit_another", "Submit another AKR sequence")
            )
          ),
          shinyjs::hidden(
            span(id = "submit_msg", "Submitting..."),
            div(id = "error",
                div(br(), tags$b("Error: "), span(id = "error_msg"))
            )
          )
        )
      )
    )
  )
)
