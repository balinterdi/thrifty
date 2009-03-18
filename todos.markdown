# TODO

## Short-term

* show all expenses by default and only show tagged ones when tags are selected
* log in user after registration

## Long-term

* validation
* make everything UTF-8 encoded
* make a form builder for the commonly used form (ul-li-label-input)

# DONE

* don't display all/none buttons when there are no tags
* display helper text when there are no expenses (and/or tags) on the expenses page
* add README
* display the user name which is converted to a navbar (including the logout button) when clicked.
* buttons to delete dates and to select all tags/none
* fix layout when subject of expense is too long
* revisit layout of the expenses page (Total amount is too close to the date filters)
* check layout of the date selectors on expenses page in Safari (looks ugly now)
* make layout of the login and register pages nice
* correct the '/' action (gives error on 'name')
* get rid of the Pot model
* rename app to "thrifty"
* add the ability of fitering expenses between two dates on expenses page
* flash messages styling
* salting user password and not storing the password itself
* make submit button nicer
* create timestamp for Expense (maybe as an after_save hook)
* make labels on form (e.g new_expense.haml) be aligned with the input fields in their row
* make bottom link shift more to the bottom
* make expenses list and total sum refresh after deleting an expense on expenses page
* fix "delete" links on expenses page
* populate should use nice user names and logins/passwords
* redirect to /expenses after logging in
* show subject of each expense on "expenses" page


