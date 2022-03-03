import { useState } from "react";
import enTranslations from "@shopify/polaris/locales/en.json";
import { AppProvider, ColorPicker, hsbToHex } from "@shopify/polaris";
import Imagepreview from "./Imagepreview";

function Quote() {
  const [quote, setQuote] = useState("quote section");
  const [color, setColor] = useState({
    hue: 300,
    brightness: 1,
    saturation: 0.7,
    alpha: 0.7,
  });

  return (
    <AppProvider i18n={enTranslations}>
      <div className="flex-col">
        <div>
          <label className="font-bold">Your Quote</label>
        </div>
        <div>
          <input
            type="text"
            onChange={(input1) => {
              setQuote(input1.target.value);
            }}
            placeholder="Your Quote"
            maxLength={100}
            className="border-2 border-black w-1/2"
          />
        </div>
      </div>
      <ColorPicker onChange={setColor} color={color} allowAlpha />
      <Imagepreview quote={quote} color={hsbToHex(color)} op={color.alpha} />
    </AppProvider>
  );
}
export default Quote;
