import "./imagepreview.css";
import * as htmlToImage from "html-to-image";
import * as download from "downloadjs";
function Imagepreview(props) {
  const downloadImage = () => {
    htmlToImage
      .toPng(document.querySelector(".imgBack"))
      .then(function (dataUrl) {
        download(dataUrl, "quote.png");
      })
      .catch(function (error) {
        console.error("oops, something went wrong!", error);
      });
  };
  return (
    <div className="imgBack" onClick={downloadImage}>
      <h1
        className="quotetxt text-clip"
        style={{ color: props.color, opacity: props.op }}
      >
        {props.quote}
      </h1>
    </div>
  );
}
export default Imagepreview;
