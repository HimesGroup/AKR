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
    output$all_akrs_a <- renderImage100("www/ALL_t.png")
    output$all_akrs_b <- renderImage100("www/ALL.png")
    output$bacteria_a <- renderImage100("www/Bacteria_t.png")
    output$bacteria_b <- renderImage100("www/Bacteria.png")
    output$fungus_a <- renderImage100("www/Fungus_t.png")
    output$fungus_b <- renderImage100("www/Fungus.png")
    output$plant_a <- renderImage100("www/Plant_t.png")
    output$plant_b <- renderImage100("www/Plant.png")
    output$mammal_a <- renderImage100("www/Mammal_t.png")
    output$mammal_b <- renderImage100("www/Mammal.png")
    output$rodent_a <- renderImage100("www/Rodent_t.png")
    output$rodent_b <- renderImage100("www/Rodent.png")
    output$human_a <- renderImage100("www/Human_t.png")
    output$human_b <- renderImage100("www/Human.png")
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
                    row.names = FALSE, quote = TRUE, sep = "\t")
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
                from = "akrsuperfamily@gmail.com",
                to = "jaehyun.joo@pennmedicine.upenn.edu",
                cc = "bhimes@pennmedicine.upenn.edu",
                subject = "New AKR sequence submission",
                text = "A new AKR sequence has been submitted. Please find the attachment."
            )
            email <- emayili::attachment(email, path = fpath, name = "submission.txt")
            smtp <- emayili::gmail(
                                 username = "akrsuperfamily@gmail.com",
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
