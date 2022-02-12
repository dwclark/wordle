(defun valid-word (w)
  (and (= 5 (length w))
       (not (find #\' w))))

(defun filter-file (lst file-name)
  (with-open-file (out file-name :direction :output :if-exists :overwrite :if-does-not-exist :create)
    (dolist (w lst)
      (if (valid-word w)
          (format out "~A~%" w)))))
