<?php

declare(strict_types=1);

namespace App\SharedKernel\Infrastructure\ValueResolver;

use App\SharedKernel\Infrastructure\Controller\ControllerInterface;
use App\SharedKernel\Infrastructure\Exception\BadRequestException\InvalidDTOException;
use App\SharedKernel\Infrastructure\RequestDTOInterface;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Controller\ValueResolverInterface;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadata;
use Symfony\Component\Serializer\SerializerInterface;

final readonly class DTOMapperResolver implements ValueResolverInterface
{
    public function __construct(
        private SerializerInterface $serializer,
    ) {
    }

    /**
     * @return array|RequestDTOInterface[]
     *
     * @throws InvalidDTOException
     */
    public function resolve(Request $request, ArgumentMetadata $argument): iterable
    {
        $controllerString = $argument->getControllerName();

        if (!$controllerString || !str_contains($controllerString, '::')) {
            return [];
        }

        $controllerClass = explode('::', $controllerString)[0];

        if (!is_a($controllerClass, ControllerInterface::class, true)) {
            return [];
        }

        $dtoClass = explode('|', $argument->getType())[0] ?? null;

        if (!$dtoClass || !class_exists($dtoClass)) {
            throw new InvalidDTOException('DTO class does not exist.');
        }

        yield $this->serializer->denormalize($this->getMergedRequestData($request), $dtoClass, 'json');
    }

    /**
     * @return array<string,mixed>
     */
    private function getMergedRequestData(Request $request): array
    {
        $queryParams = $request->query->all();

        $bodyContent = $this->getRequestData($request);

        $fileParams = [];
        foreach ($request->files->all() as $key => $file) {
            if (is_array($file)) {
                $fileParams[$key] = array_map(fn ($f) => $this->normalizeFile($f), $file);
            } else {
                $fileParams[$key] = $this->normalizeFile($file);
            }
        }

        return array_merge($queryParams, $bodyContent, $fileParams);
    }

    /**
     * @return array<string,mixed>
     */
    private function getRequestData(Request $request): array
    {
        $content = $request->getContent();

        if (empty($content)) {
            return [];
        }

        $data = json_decode($content, true);

        return JSON_ERROR_NONE === json_last_error() ? $data : [];
    }

    /**
     * @return array<string,string>
     */
    private function normalizeFile(UploadedFile $file): array
    {
        return [
            'name' => $file->getClientOriginalName(),
            'mimeType' => $file->getClientMimeType(),
            'size' => $file->getSize(),
            'path' => $file->getRealPath(),
        ];
    }
}
