#
# * Readers
# * A polyfill for a more accessible HTML5 on screen readers
# *
# * Cloned from "accessifyhtml5.js"
# * Copyright © 2014 Eric Eggert ("accessifyhtml5.js"), Softlayer, an IBM Company
# * Released under the MIT license
#

AccessifyHTML5 = (defaults, more_fixes) ->
  "use strict"
  fixes =
    article:
      role: "article"

    aside:
      role: "complementary"

    nav:
      role: "navigation"

    main:
      role: "main"

    output:
      "aria-live": "polite"

    section:
      role: "region"

    "[required]":
      "aria-required": "true"

  result =
    ok: []
    warn: []
    fail: []

  error = result.fail
  ATTR_SECURE = new RegExp("aria-[a-z]+|role|tabindex|title|alt|data-[\\w-]+|lang|" + "style|maxlength|placeholder|pattern|required|type|target|accesskey|longdesc")
  ID_PREFIX = "acfy-id-"
  n_label = 0
  Doc = document
  if Doc.querySelectorAll
    if defaults
      fixes[defaults.header] = role: "banner"  if defaults.header
      fixes[defaults.footer] = role: "contentinfo"  if defaults.footer
      if defaults.main
        fixes[defaults.main] = role: "main"
        fixes.main = role: ""

    if more_fixes and more_fixes._CONFIG_ and more_fixes._CONFIG_.ignore_defaults
      fixes = more_fixes
    else

      for mo of more_fixes
        fixes[mo] = more_fixes[mo]
    for fix of fixes
      continue  if fix.match(/^_(CONFIG|[A-Z]+)_/)
      if fixes.hasOwnProperty(fix)

        try
          elems = Doc.querySelectorAll(fix)
        catch ex
          error.push
            sel: fix
            attr: null
            val: null
            msg: "Invalid syntax for `document.querySelectorAll` function"
            ex: ex

        obj = fixes[fix]
        if not elems or elems.length < 1
          result.warn.push
            sel: fix
            attr: null
            val: null
            msg: "Not found"

        i = 0
        while i < elems.length
          for key of obj
            if obj.hasOwnProperty(key)
              attr = key
              value = obj[key]

              continue  if attr.match(/_?note/)
              unless attr.match(ATTR_SECURE)
                error.push
                  sel: fix
                  attr: attr
                  val: null
                  msg: "Attribute not allowed"
                  re: ATTR_SECURE

                continue
              unless (typeof value).match(/string|number|boolean/)
                error.push
                  sel: fix
                  attr: attr
                  val: value
                  msg: "Value-type not allowed"

                continue

              by_match = attr.match(/(describ|label)l?edby/)
              if by_match
                try
                  el_label = Doc.querySelector(value)
                catch ex
                  error.push
                    sel: fix
                    attr: attr
                    val: value
                    msg: "Invalid selector syntax (2) - see 'val'"
                    ex: ex

                unless el_label
                  error.push
                    sel: fix
                    attr: attr
                    val: value
                    msg: "Labelledby ref not found - see 'val'"

                  continue
                el_label.id = ID_PREFIX + n_label  unless el_label.id
                value = el_label.id
                attr = "aria-" + ((if "label" is by_match[1] then "labelledby" else "describedby"))
                n_label++
              unless elems[i].hasAttribute(attr)
                elems[i].setAttribute attr, value
                result.ok.push
                  sel: fix
                  attr: attr
                  val: value
                  msg: "Added"

              else
                result.warn.push
                  sel: fix
                  attr: attr
                  val: value
                  msg: "Already present, skipped"

          i++
  result.input = fixes
  result
