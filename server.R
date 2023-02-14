server <- function(input, output, session) {
  ## Nav title will serve as a home tab
  observeEvent(input$title, {
    updateNavbarPage(session, "main", "Home")
  })
  output$existing <- DT::renderDataTable(
    DT::datatable(existing_members, escape = FALSE)
  )
  output$potential <- DT::renderDataTable(
    DT::datatable(potential_members, escape = FALSE)
  )
  output$pdb <- DT::renderDataTable(DT::datatable(pdb_list, escape = FALSE))
  output$AKR_trees <- renderUI({
    switch(input$Phylogeny,
           "Overview" = renderImageWidthPct("www/All_AKR.png"),
           "AKR1" = renderImageWidthPct("www/AKR1.png"),
           "AKR2" = renderImageWidthPct("www/AKR2.png"),
           "AKR3" = renderImageWidthPct("www/AKR3.png"),
           "AKR4" = renderImageWidthPct("www/AKR4.png"),
           "AKR5" = renderImageWidthPct("www/AKR5.png"),
           "AKR6" = renderImageWidthPct("www/AKR6.png"),
           "AKR7" = renderImageWidthPct("www/AKR7.png"),
           "AKR9" = renderImageWidthPct("www/AKR9.png"),
           "AKR11" = renderImageWidthPct("www/AKR11.png"),
           "AKR12" = renderImageWidthPct("www/AKR12.png"),
           "AKR13" = renderImageWidthPct("www/AKR13.png"),
           "Eukaryote" = renderImageWidthPct("www/Eukaryote.png"),
           "Animalia" = renderImageWidthPct("www/Kingdom_Animalia.png"),
           "Bacteria" = renderImageWidthPct("www/Kingdom_Bacteria.png"),
           "Fungi" = renderImageWidthPct("www/Kingdom_Fungi.png"),
           "Plantae" = renderImageWidthPct("www/Kingdom_Plante.png"),
           "Amphibia" = renderImageWidthPct("www/Class_Amphibia.png"),
           "Insecta" = renderImageWidthPct("www/Class_Insecta.png"),
           "Mammalia" = renderImageWidthPct("www/Class_Mammalia.png"),
           "Anura" = renderImageWidthPct("www/Order_Anura.png"),
           "Artiodactyla" = renderImageWidthPct("www/Order_Artiodactyla.png"),
           "Lagomorpha" = renderImageWidthPct("www/Order_Lagomorpha.png"),
           "Lepidoptera" = renderImageWidthPct("www/Order_Lepidoptera.png"),
           "Rodentia" = renderImageWidthPct("www/Order_Rodentia.png"),
           "Human" = renderImageWidthPct("www/Human.png")
    )
  })
  ## AKR submission form
  observe({
    ## check if all mandatory fields have a value
    mandatory_filled <-
      vapply(mandatory_fields,
             function(x) {
               !is.null(input[[x]]) && input[[x]] != ""
             },
             logical(1))
    mandatory_filled <- all(mandatory_filled)
    ## enable/disable the submit button
    shinyjs::toggleState(id = "submit", condition = mandatory_filled)
  })
  submission_data <- reactive({
    d <- sapply(all_fields, function(x) input[[x]])
    d <- c(d, timestamp = epoch_time())
    data.frame(x = names(d), y = d)
  })
  save_submission_data <- function(d) {
    fname <- sprintf("%s_%s.txt",
                     human_time(),
                     digest::digest(d))
    fpath <- file.path(submission_dir, fname)
    write.table(x = d, file = fpath, col.names = FALSE,
                row.names = FALSE, quote = FALSE, sep = "\t")
    fpath
  }
  ## action to take when submit button is pressed
  observeEvent(input$submit, {
    shinyjs::disable("submit")
    shinyjs::show("submit_msg")
    shinyjs::hide("error")
    tryCatch({
      fpath <- save_submission_data(submission_data())
      shinyjs::reset("form")
      shinyjs::hide("form")
      shinyjs::show("thankyou_msg")
      email <- emayili::envelope(
        from = "akrsuperfamily@outlook.com",
        to = "penning@upenn.edu",
        cc = c("bhimes@pennmedicine.upenn.edu", "jaehyun.joo@pennmedicine.upenn.edu"),
        subject = "New AKR sequence submission",
        text = "A new AKR sequence has been submitted. Please find the attachment."
      )
      email <- emayili::attachment(email, path = fpath, name = "submission.txt")
      smtp <- emayili::server(
        host = "smtp-mail.outlook.com",
        port = 587,
        username = "akrsuperfamily@outlook.com",
        password = email_pw,
        max_times = 1
      )
      smtp(email)
    },
    error = function(err) {
      shinyjs::html("error_msg", err$message)
      shinyjs::show(id = "error", anim = TRUE, animType = "fade")
    },
    finally = {
      shinyjs::enable("submit")
      shinyjs::hide("submit_msg")
    })
  })
  observeEvent(input$submit_another, {
    shinyjs::show("form")
    shinyjs::hide("thankyou_msg")
  })
  output$msa_viewer <- renderMsaR(
    msaR(read_akr_msa(input$msa_dropdown), color = "taylor")
  )
}
