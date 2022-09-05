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
  output$family_tree <- renderImage({
    list(
      src = file.path("www/family_tree.png"),
      width = "70%",
      ## width = 850,
      ## height = 800,
      style="display: block; margin-left: auto; margin-right: auto;"
    )
  }, deleteFile = FALSE)
  output$AKR_trees <- renderUI({
    switch(input$Phylogeny,
           "Overview" = renderImage100("www/All_AKRs_color_coded.png"),
           "AKR1" = renderImage100("www/AKR1.png"),
           "AKR2" = renderImage100("www/AKR2.png"),
           "AKR3" = renderImage100("www/AKR3.png"),
           "AKR4" = renderImage100("www/AKR4.png"),
           "AKR5" = renderImage100("www/AKR5.png"),
           "AKR6" = renderImage100("www/AKR6.png"),
           "AKR7" = renderImage100("www/AKR7.png"),
           ## "AKR8" = renderImage100("www/AKR8.png"),
           "AKR9" = renderImage100("www/AKR9.png"),
           ## "AKR10" = renderImage100("www/AKR10.png"),
           "AKR11" = renderImage100("www/AKR11.png"),
           "AKR12" = renderImage100("www/AKR12.png"),
           "AKR13" = renderImage100("www/AKR13.png"),
           ## "All AKRs" = renderImage100("www/ALL_t.png"),
           "Bacterial AKRs" = renderImage100("www/Bacteria.png"),
           "Fungal AKRs" = renderImage100("www/Fungus.png"),
           "Plant AKRs" = renderImage100("www/Plant.png"),
           "Mammalian AKRs" = renderImage100("www/Mammal.png"),
           "Rodent AKRs" = renderImage100("www/Rodent.png"),
           "Human AKRs" = renderImage100("www/Human.png"),
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
