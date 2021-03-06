(in-package :cl-user)
(defpackage darkmatter.eval
  (:use :cl)
  (:import-from :alexandria
                :if-let)
  (:import-from :cl-markup
                :markup
                :escape-string)
  (:import-from :darkmatter.pacman
                :get-package
                :make-temporary-package)
  (:import-from :darkmatter.async
                :check-task
                :attach-runtask
                :attach-task-thread))
(in-package :darkmatter.eval)

(defmacro farguments (symbol)
  `(third (function-lambda-expression (symbol-function ,symbol))))

(defmacro marguments (symbol)
  `(third (car (last (function-lambda-expression (macro-function ,symbol))))))

(defun symbol-detail (symbol)
  (let ((name (symbol-name symbol)))
    (cond
      ((macro-function symbol)
       `(:obj ("type" . "macro")
         ("doc" . ,(documentation symbol 'function))
         ("arguments" . ,(marguments symbol))))
      ((fboundp symbol)
       `(:obj ("type" . "function")
         ("doc" . ,(documentation symbol 'function))
         ("arguments" . ,(farguments symbol))))
      ((find-class symbol nil)
       `(:obj ("type" . "class")
         ("doc" . ,(documentation symbol 'type))))
      ((boundp symbol)
       `(:obj ("type" . "variable")
         ("doc" . ,(documentation symbol 'variable))))
      (t
       `(:obj ("type" . "symbol"))))))

(defun eval-string (path src cell id)
  (format t "Come: ~A~%" src)
  (let* ((standard-output *standard-output*)
         (*standard-output* (make-string-output-stream))
         (*error-output* (make-string-output-stream))
         (pkg (or (get-package path)
                  (let ((new-package (make-temporary-package path)))
                    (cons new-package (package-name new-package)))))
         (*package* (or (find-package (cdr pkg))
                        (car pkg)))
         (sexp nil)
         (symbols `(:obj))
         (return-value nil)
         (pos 0))
    (handler-case
        (loop while pos
              do (multiple-value-setq (sexp pos)
                   (read-from-string src :eof-error-p t :start pos))
                 (setf sexp (attach-runtask sexp))
                 (setf return-value (eval sexp))
                 (when (symbolp return-value)
                   (setf symbols
                         (append symbols
                                 (list
                                  (cons (symbol-name return-value)
                                        (symbol-detail return-value)))))))
      (end-of-file (c) nil)
      (error (c) (format t "<pre>~A</pre>" c)))
    (setf (cdr (gethash path darkmatter.pacman:*local-packages*)) (package-name *package*))
    (let (($<error-output> (get-output-stream-string *error-output*))
          ($<standard-output> (get-output-stream-string *standard-output*))
          (*package* (find-package :darkmatter)))
      (format standard-output "Result:~A~%~A~%" return-value $<standard-output>)
      (if-let (task (check-task id return-value))
        (progn
          (setf (jsown:val task "symbols") symbols)
          task)
        `(:obj ("message" . "result")
          ("return" .
           ,(escape-string (format nil "~A" return-value)))
          ("symbols" . ,symbols)
          ("output" .
           ,(format nil "~A~A"
                    (if (string= "" $<error-output>)
                        ""
                        (markup (:pre $<error-output>)))
                    (string-left-trim '(#\Space #\Newline) $<standard-output>))))))))

