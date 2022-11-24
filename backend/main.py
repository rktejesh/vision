from fastapi import FastAPI, File, UploadFile, HTTPException
from PIL import Image
import uvicorn
from os import getcwd, remove
from fastapi.responses import FileResponse, JSONResponse

# define the fastAPI
app = FastAPI()

# define response
@app.get("/")
def root_route():
	return {'error': 'Use GET /upload instead of the root route!'}

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    with open(file.filename, 'wb') as image:
        content = await file.read()
        image.write(content)
        image.close()
    return FileResponse(path=getcwd() + "/" + file.filename)

@app.get("/file/{name_file}")
def get_file(name_file: str):
    return FileResponse(path=getcwd() + "/" + name_file)

@app.delete("/delete/file/{name_file}")
def delete_file(name_file: str):
    try:
        remove(getcwd() + "/" + name_file)
        return JSONResponse(content={
            "removed": True
            }, status_code=200)   
    except FileNotFoundError:
        return JSONResponse(content={
            "removed": False,
            "error_message": "File not found"
        }, status_code=404)

if __name__ == '__main__':
	uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)