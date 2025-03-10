#' Radio question
#'
#' Creates a radio button tutorial quiz question.  The student can select only
#' one radio button before submitting their answer.
#'
#' Note: Multiple correct answers are allowed.
#'
#'
#' @inheritParams question
#' @param ... answers and extra parameters passed onto \code{\link{question}}.
#' @seealso \code{\link{question_checkbox}}, \code{\link{question_text}}, \code{\link{question_numeric}}
#' @export
#' @examples
#' question_radio(
#'   "Pick the letter B",
#'   answer("A"),
#'   answer("B", correct = TRUE),
#'   answer("C"),
#'   answer("D"),
#'   allow_retry = TRUE,
#'   random_answer_order = TRUE
#' )
question_radio <- function(
  text,
  ...,
  correct = "Correct!",
  incorrect = "Incorrect",
  try_again = incorrect,
  allow_retry = FALSE,
  random_answer_order = FALSE
) {
  learnr::question(
    text = text,
    ...,
    type = "learnr_radio",
    correct = correct,
    incorrect = incorrect,
    allow_retry = allow_retry,
    random_answer_order = random_answer_order
  )
}





#' @export
question_ui_initialize.learnr_radio <- function(question, value, ...) {
  choice_names <- answer_labels(question)
  choice_values <- answer_values(question)

  radioButtons(
    question$ids$answer,
    label = question$question,
    choiceNames = choice_names,
    choiceValues = choice_values,
    selected = value %||% character(0) # avoid selecting the first item when value is NULL
  )
}


# question_is_valid.radio <- question_is_valid.default


#' @export
question_is_correct.learnr_radio <- function(question, value, ...) {
  for (ans in question$answers) {
    if (as.character(ans$option) == value) {
      return(mark_as(
        ans$correct,
        ans$message
      ))
    }
  }
  mark_as(FALSE, NULL)
}


#' @export
question_ui_completed.learnr_radio <- function(question, value, ...) {
  choice_values <- answer_values(question)

  # update select answers to have X or √
  choice_names_final <- lapply(question$answers, function(ans) {
    if (ans$correct) {
      tagClass <- "correct"
    } else {
      tagClass <- "incorrect"
    }
    tags$span(ans$label, class = tagClass)
  })

  finalize_question(
    radioButtons(
      question$ids$answer,
      label = question$question,
      choiceValues = choice_values,
      choiceNames = choice_names_final,
      selected = value
    )
  )
}
