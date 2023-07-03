make_quarto <- function(files, 
                        destfiles = NULL, 
                        output_ext = ".html", 
                        ...) {
  
  if (is.null(destfiles)) destfiles <- paste0(tools::file_path_sans_ext(files), output_ext)
  
  t <- file.info(destfiles[1])$ctime
  
  for (i in seq_along(files)) {
    if (
      # render file if source is newer than destination
      isTRUE(file.info(files[i])$ctime >= file.info(destfiles[i])$ctime) || 
      # or if output is NOT newer than previous destination file
      !isTRUE(file.info(destfiles[i])$ctime >= t) 
    ) {
      cli::cli_progress_step("Making {destfiles[i]}.")
      quarto::quarto_render(
        input = files[i],
        output_file = destfiles[i]
      )
      cli::cli_progress_done()
    } else {
      cli::cli_inform(c("v" = "{destfiles[i]} already up to date."))
    }
    t <- file.info(destfiles[i])$ctime
  }
  
}

make_quarto(files = c(
  "1_Obtaining_Text_Data.qmd",
  "2_Regression_and_Scaling.qmd",
  "3._Supervised_Classification_Methods.qmd"
))
