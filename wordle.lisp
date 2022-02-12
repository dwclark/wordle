(defun read-file (file-name)
  (with-open-file (stm file-name)
    (loop for line = (read-line stm nil)
          while line
          collect line)))

(defun letter-in-position (str)
  (if (and (= 2 (length str))
           (not (char= #\! (elt str 0))))
      (let ((pos (- (char-code (elt str 0)) 49))
            (ch (elt str 1)))
        #'(lambda (word)
            (char= ch (elt word pos))))))

(defun no-letter (str)
  (if (and (= 2 (length str))
           (char= #\! (elt str 0)))
      (let ((ch (elt str 1)))
        #'(lambda (word)
            (not (find ch word :test #'char=))))))

(defun letter-not-in-position (str)
  (if (= 3 (length str))
      (let ((pos (- (char-code (elt str 1)) 49))
            (ch (elt str 2)))
        #'(lambda (word)
            (and (find ch word :test #'char=)
                 (not (char= ch (elt word pos))))))))

(defun sym->func (s)
  (let ((str (string-downcase (symbol-name s))))
    (or (letter-in-position str)
        (no-letter str)
        (letter-not-in-position str))))
                      
(defun funcs-matcher (specs)
  (let ((funcs (mapcar #'sym->func specs)))
    #'(lambda (word)
        (loop for func in funcs
              do (if (not (funcall func word))
                     (return nil))
              finally (return t)))))

(defun best-guess-p (word)
  (let ((my-set nil))
    (loop for ch across word
          do (setf my-set (adjoin ch my-set :test #'char=))
          finally (return (if (= 5 (length my-set)) t nil)))))

(defun possibilities (file-name specs)
  (let* ((all (remove-if-not (funcs-matcher specs) (read-file file-name)))
         (best-guesses (remove-if-not #'best-guess-p all)))
    (format t "All:~%~A~%~%" all)
    (format t "Best Guesses: ~%~A~%~%" best-guesses)))
        
(defmacro play-wordle (file-name &rest specs)
  `(funcall #'possibilities ,file-name '(,@specs)))
