## Handling SSL Certs

The original post from [here](https://blog.bigdinosaur.org/openfire-and-ssl-slash-tls-certificates/) makes reference to how old it is and that it potentially has outdated/incorrect information. Since it gets older every day, and since it might vanish at any time, I'm porting the relevant information to here.

### Prepare your SSL certificates

1. Save your certificate, keyfile, and (if necessary) CA certificate in `/<container-home>/security`
  * These instructions will assume the names of `openfire.crt`, `openfire.key` and `ca.crt` for the Intermediate CA certificate. When asked for a password, if you haven't changed it, use the default password of `changeit`.
2. Convert your certificate
```
openssl x509 -in /openfire.crt -inform PEM -out ./cert.der -outform DER
```
3. Convert your key
```
openssl pkcs8 -topk8 -nocrypt -in /openfire.key -inform PEM -out ./key.der -outform DER
```
4. Convert your CA certificate (if necessary)
```
openssl x509 -in /openfire.crt -inform PEM -out ./cert.der -outform DER
```
5. Concatenate your cert with the CA cert (if necessary)
```
cat cert.der ca.der > chaincert.der
```

At this point the post provides the source for `KeyStoreImport.java`, but I've provided that and a compiled classfile in this repo.

### Backup your SSL stores

Just in case.

```
cp truststore truststore-knowngood
cp keystore keystore-knowngood
```

### Connect to your container

If you have a JVM on your Docker host, you can run the `keytool` command locally. If you don't, you'll need to first connect to the container before following the remaining steps.
```
docker exec -it <container> /bin/ash
cd /usr/share/openfire/resources/security
```

### Check that truststore has your CA in it

Search through the output of `keytool -list -keystore truststore` for your CA. If it's not present, find their root certificate and import it. The example presumes that the CA root certificate is in the current directory as `ca.cer`.

```
keytool -importcert -alias "myrootca" -keystore truststore -file ca.cer
```

After doing the import, run `keytool -list -keystore truststore` again and make sure that the certificate was imported properly.

### Purge the keystore of current certs

Run `keytool -list -keystore keystore` to list the current certs. If this is your first time through, you'll have two certs, aliased as `rsa` and `dsa`. If you're renewing your certificate, you'll have a different alias. In any case, delete everything that's there.
```
keytool -delete -keystore keystore -alias <alias>
```

Repeat that command for all aliases that exist.

### Import your new certificate

You should have `KeyStoreImport.class` in the directory where you're working, since it's installed as part of the container. Use this to import your new certificate. You will be asked for two passwords - the first is the keystore password you've been using. The second is the password that Openfire uses to access the private key. This is set to `changeit` by default within Openfire, so unless you've changed it, enter that here as well.
```
java KeyStoreImport keystore cert.der key.der "alias-for-your-cert"

Keystore password:
changeit
Private key entry password:
changeit
```


## Refreshing Your Certificate

When your SSL cert expires, follow the same steps above. The only part that is different is the alias you'll be deleting. There will only be one cert, the certificate that you originally added. There's no need to restart Openfire or the container or anything - it picks up the new cert and starts using it right away.

