## Wiki Password Generator (`wiki-pwd.sh`)

The `wiki-pwd.sh` script is a simple password generator that fetches content from Wikipedia's random pages and constructs a password using random words from the content.

### Prerequisites

- `curl`
- `xmllint`

Ensure these are installed on your system before using the script.

### Usage

```bash
./wiki-pwd.sh [options]
```

#### Options:

- `-w <number>`: Specifies the number of words to be included in the password. Default is 4.
  
  Example:
  ```bash
  ./wiki-pwd.sh -w 5
  ```

- `-s <string> <count>`: Introduces random characters from a provided string to the generated password. Requires two arguments: the string and the count of characters you want to add.

  Example:
  ```bash
  ./wiki-pwd.sh -s "!@#%&*" 2
  ```

The above command might produce a password like `WordOneWordTwo!%`.

#### Output:

The script outputs the title of the Wikipedia page it's using, the number of `<p>` tags found on the page, and then the generated password.

#### Examples:

Generate a password with the default 4 words:

```bash
./wiki-pwd.sh
```

Generate a password with 5 words and add 2 special characters from the set `!@#%&*`:

```bash
./wiki-pwd.sh -w 5 -s "!@#%&*" 2
```

### Notes:

- The script ensures that the words selected for the password are at least 4 letters long.
- Every word in the password is capitalized by default.
- If the Wikipedia page fetched has less than 5 `<p>` tags, the script will fetch a new page.
